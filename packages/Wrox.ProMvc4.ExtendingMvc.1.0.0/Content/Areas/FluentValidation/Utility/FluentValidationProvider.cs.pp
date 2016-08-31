using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text.RegularExpressions;
using System.Web.Mvc;

namespace $rootnamespace$.Areas.FluentValidation.Utility
{
    public class FluentValidationProvider : ModelValidatorProvider
    {
        // A validator factory takes in the model metadata and controller context and
        // manufactures a model validator that is contextually appropriate for this request.
        delegate ModelValidator ValidatorFactory(ModelMetadata metadata, ControllerContext context);

        // This dictionary is a mapping from incoming validator request to a list of
        // factories that will make validator instances. The incoming validator request
        // might be for just a type (so, getting validators on a class), in which case
        // the key tuple will contain the type and a null value for the string; if
        // the incoming request is for a property, then the key tuple will contain
        // the container type and the name of the property.
        ConcurrentDictionary<Tuple<Type, string>, List<ValidatorFactory>> validators =
            new ConcurrentDictionary<Tuple<Type, string>, List<ValidatorFactory>>();

        // This method is called by the registrar class so that it can add validator
        // factories to the given registration.
        private void Add(Type type, string propertyName, ValidatorFactory factory)
        {
            validators.GetOrAdd(
                new Tuple<Type, string>(type, propertyName),
                _ => new List<ValidatorFactory>()
            ).Add(factory);
        }

        // This method is called by the developer to get an instance of the registrar which
        // can be used to record model-level validation rules.
        public ValidatorRegistrar<TModel> ForModel<TModel>()
        {
            return new ValidatorRegistrar<TModel>(this);
        }

        public override IEnumerable<ModelValidator> GetValidators(ModelMetadata metadata, ControllerContext context)
        {
            // Start with an empty result set
            IEnumerable<ModelValidator> results = Enumerable.Empty<ModelValidator>();

            // If the user wants validation on a property, then we start out with the validators
            // that are applied directly to that property.
            if (metadata.PropertyName != null)
                results = GetValidators(metadata, context, metadata.ContainerType, metadata.PropertyName);

            // Whether this is a property level validation request or not, we always want to include
            // any validators which are attached directly to the type that's requested, whether it's
            // a property of a model or a full model.
            return results.Concat(GetValidators(metadata, context, metadata.ModelType));
        }

        private IEnumerable<ModelValidator> GetValidators(ModelMetadata metadata,
                                                            ControllerContext context,
                                                            Type type,
                                                            string propertyName = null)
        {
            // Look up the validator factories in the dictionary and run them all
            var key = new Tuple<Type, string>(type, propertyName);
            List<ValidatorFactory> factories;
            if (validators.TryGetValue(key, out factories))
                foreach (var factory in factories)
                    yield return factory(metadata, context);
        }

        // The ValidatorRegistrar class is the core type that records registrations. It
        // contains methods which add validator factories to the provider list. Because this
        // is a fluent API, we always return an instance of ourselves so that we can chain
        // calls together.
        public class ValidatorRegistrar<TModel>
        {
            private FluentValidationProvider provider;
            private string propertyName;

            public ValidatorRegistrar(FluentValidationProvider provider, string propertyName = null)
            {
                this.provider = provider;
                this.propertyName = propertyName;
            }

            public ValidatorRegistrar<TModel> EmailAddress(string errorMessage = "{0} must be an e-mail address")
            {
                provider.Add(
                    typeof(TModel),
                    propertyName,
                    (metadata, context) => new EmailAddressValidator(metadata, context, errorMessage)
                );

                return this;
            }

            public ValidatorRegistrar<TModel> Required(string errorMessage = "{0} is required")
            {
                provider.Add(
                    typeof(TModel),
                    propertyName,
                    (metadata, context) => new RequiredValidator(metadata, context, errorMessage)
                );

                return this;
            }

            public ValidatorRegistrar<TModel> StringLength(int? minLength = null, int? maxLength = null, string errorMessage = null)
            {
                // Contextual message, depending on whether they provided a min and/or max length
                if (errorMessage == null)
                    if (minLength != null)
                        if (maxLength != null)
                            errorMessage = "{0} must be between {1} and {2} characters long";
                        else
                            errorMessage = "{0} must be at least {1} characters long";
                    else
                        errorMessage = "{0} must be no more than {2} characters long";

                provider.Add(
                    typeof(TModel),
                    propertyName,
                    (metadata, context) => new StringLengthValidator(metadata,
                                                                     context,
                                                                     errorMessage,
                                                                     minLength ?? 0,
                                                                     maxLength ?? Int32.MaxValue)
                );

                return this;
            }

            // Support implicit conversion back to the provider, so that the user can create,
            // configure, and register the provider with a single line of code.
            public static implicit operator FluentValidationProvider(ValidatorRegistrar<TModel> registrar)
            {
                return registrar.provider;
            }

            // This method is like ForModel above, except that it lets the developer transition
            // to a new model without needing to go back to the registrar itself.
            public ValidatorRegistrar<TNewModel> ForModel<TNewModel>()
            {
                return new ValidatorRegistrar<TNewModel>(provider);
            }

            // This method is called by the developer to get an instance of the registrar which
            // can be used to record property-level validation rules. We use Expression<T> here
            // so that the user can get Intellisense for the property expression, and also so
            // that their registration code can support refactoring operations like renaming
            // properties on models.
            public ValidatorRegistrar<TModel> ForProperty(Expression<Func<TModel, object>> expression)
            {
                return new ValidatorRegistrar<TModel>(provider, ExpressionToPropertyName(expression));
            }

            // This is a built-in validator which supports Required validation
            private class RequiredValidator : ModelValidator
            {
                private string errorMessage;

                public RequiredValidator(ModelMetadata metadata, ControllerContext context, string errorMessage)
                    : base(metadata, context)
                {
                    this.errorMessage = errorMessage;
                }

                public override bool IsRequired
                {
                    get { return true; }
                }

                private string ErrorMessage
                {
                    get
                    {
                        return String.Format(errorMessage, Metadata.GetDisplayName());
                    }
                }

                public override IEnumerable<ModelClientValidationRule> GetClientValidationRules()
                {
                    yield return new ModelClientValidationRequiredRule(ErrorMessage);
                }

                public override IEnumerable<ModelValidationResult> Validate(object container)
                {
                    if (Metadata.Model == null)
                        yield return new ModelValidationResult { Message = ErrorMessage };
                }
            }

            // This is a built-in validator which supports string length validation.
            private class StringLengthValidator : ModelValidator
            {
                private string errorMessage;
                private int minLength;
                private int maxLength;

                public StringLengthValidator(ModelMetadata metadata, ControllerContext context, string errorMessage, int minLength, int maxLength)
                    : base(metadata, context)
                {
                    this.errorMessage = errorMessage;
                    this.minLength = minLength;
                    this.maxLength = maxLength;
                }

                private string ErrorMessage
                {
                    get
                    {
                        return String.Format(errorMessage, Metadata.GetDisplayName(), minLength, maxLength);
                    }
                }

                public override IEnumerable<ModelClientValidationRule> GetClientValidationRules()
                {
                    yield return new ModelClientValidationStringLengthRule(ErrorMessage, minLength, maxLength);
                }

                public override IEnumerable<ModelValidationResult> Validate(object container)
                {
                    // We should never fail when the Model is null, because all validators (except required)
                    // should no-op when given no value. The developer is responsible for adding the required
                    // validation rule when a value is mandator, so all other validators just assume that
                    // null is valid.
                    if (Metadata.Model != null)
                    {
                        string modelAsString = Metadata.Model.ToString();

                        if (modelAsString.Length < minLength || modelAsString.Length > maxLength)
                            yield return new ModelValidationResult { Message = ErrorMessage };
                    }
                }
            }

            // This is a built-in validator for e-mail addresses
            private class EmailAddressValidator : ModelValidator
            {
                private string errorMessage;
                private static Regex regex = new Regex("^((([a-z]|\\d|[!#\\$%&'\\*\\+\\-\\/=\\?\\^_`{\\|}~]|[\\u00A0-\\uD7FF\\uF900-\\uFDCF\\uFDF0-\\uFFEF])+(\\.([a-z]|\\d|[!#\\$%&'\\*\\+\\-\\/=\\?\\^_`{\\|}~]|[\\u00A0-\\uD7FF\\uF900-\\uFDCF\\uFDF0-\\uFFEF])+)*)|((\\x22)((((\\x20|\\x09)*(\\x0d\\x0a))?(\\x20|\\x09)+)?(([\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x7f]|\\x21|[\\x23-\\x5b]|[\\x5d-\\x7e]|[\\u00A0-\\uD7FF\\uF900-\\uFDCF\\uFDF0-\\uFFEF])|(\\\\([\\x01-\\x09\\x0b\\x0c\\x0d-\\x7f]|[\\u00A0-\\uD7FF\\uF900-\\uFDCF\\uFDF0-\\uFFEF]))))*(((\\x20|\\x09)*(\\x0d\\x0a))?(\\x20|\\x09)+)?(\\x22)))@((([a-z]|\\d|[\\u00A0-\\uD7FF\\uF900-\\uFDCF\\uFDF0-\\uFFEF])|(([a-z]|\\d|[\\u00A0-\\uD7FF\\uF900-\\uFDCF\\uFDF0-\\uFFEF])([a-z]|\\d|-|\\.|_|~|[\\u00A0-\\uD7FF\\uF900-\\uFDCF\\uFDF0-\\uFFEF])*([a-z]|\\d|[\\u00A0-\\uD7FF\\uF900-\\uFDCF\\uFDF0-\\uFFEF])))\\.)+(([a-z]|[\\u00A0-\\uD7FF\\uF900-\\uFDCF\\uFDF0-\\uFFEF])|(([a-z]|[\\u00A0-\\uD7FF\\uF900-\\uFDCF\\uFDF0-\\uFFEF])([a-z]|\\d|-|\\.|_|~|[\\u00A0-\\uD7FF\\uF900-\\uFDCF\\uFDF0-\\uFFEF])*([a-z]|[\\u00A0-\\uD7FF\\uF900-\\uFDCF\\uFDF0-\\uFFEF])))\\.?$", RegexOptions.IgnoreCase | RegexOptions.Compiled);

                public EmailAddressValidator(ModelMetadata metadata, ControllerContext context, string errorMessage)
                    : base(metadata, context)
                {
                    this.errorMessage = errorMessage;
                }

                private string ErrorMessage
                {
                    get
                    {
                        return String.Format(errorMessage, Metadata.GetDisplayName());
                    }
                }

                public override IEnumerable<ModelClientValidationRule> GetClientValidationRules()
                {
                    yield return new ModelClientValidationRule { ValidationType = "email", ErrorMessage = ErrorMessage };
                }

                public override IEnumerable<ModelValidationResult> Validate(object container)
                {
                    if (Metadata.Model != null)
                    {
                        string modelAsString = Metadata.Model.ToString();

                        if (regex.Match(modelAsString).Length == 0)
                            yield return new ModelValidationResult { Message = ErrorMessage };
                    }
                }
            }

            // This helper method extracts the property name from the Expression<T>
            private static string ExpressionToPropertyName(Expression<Func<TModel, object>> expression)
            {
                Expression body = expression.Body;

                UnaryExpression unaryExpression = body as UnaryExpression;
                if (unaryExpression != null && unaryExpression.NodeType == ExpressionType.Convert)  // Boxing value type to object
                    body = unaryExpression.Operand;

                MemberExpression memberExpression = (MemberExpression)body;
                return memberExpression.Member.Name;
            }
        }
    }
}
