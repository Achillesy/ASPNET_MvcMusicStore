using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq.Expressions;
using System.Web.Mvc;

namespace $rootnamespace$.Areas.FluentMetadata.Utility
{
    public class FluentMetadataProvider : DataAnnotationsModelMetadataProvider
    {
        // This dictionary is a mapping from incoming metadata request to a list of
        // functions which will modify the metadata. The incoming metadata request
        // might be for just a type (so, getting metadata on a class), in which case
        // the key tuple will contain the type and a null value for the string; if
        // the incoming request is for a property, then the key tuple will contain
        // the container type and the name of the property.
        ConcurrentDictionary<Tuple<Type, string>, List<Action<ModelMetadata>>> modifiers
            = new ConcurrentDictionary<Tuple<Type, string>, List<Action<ModelMetadata>>>();

        protected override ModelMetadata CreateMetadata(IEnumerable<Attribute> attributes,
                                                        Type containerType,
                                                        Func<object> modelAccessor,
                                                        Type modelType,
                                                        string propertyName)
        {
            // We've derived from DataAnnotationsModelMetadataProvider so that we can
            // mix both attribute-based metadata and the fluent metadata. We want the
            // fluent metadata to override the attributes, so we start by calling the
            // base CreateMetadata method so we can get those values.
            ModelMetadata metadata = base.CreateMetadata(attributes, containerType, modelAccessor, modelType, propertyName);

            // Next, we determine the request type. If the property name is null, then
            // we're being asked for model-level metadata; otherwise, we're being asked
            // for property-level metadata. We make a tuple which matches the type of
            // request we're being asked to perform.
            Tuple<Type, string> key = propertyName == null ? new Tuple<Type, string>(modelType, null)
                                                            : new Tuple<Type, string>(containerType, propertyName);

            // If we have any modifier functions that match the requested key tuple, then
            // we'll loop over them and run them all.
            List<Action<ModelMetadata>> modifierList;
            if (modifiers.TryGetValue(key, out modifierList))
                foreach (Action<ModelMetadata> modifier in modifierList)
                    modifier(metadata);

            return metadata;
        }

        // This method is called by the registrar class so that it can add modification
        // actions to the given registration.
        private void Add(Type type, string propertyName, Action<ModelMetadata> modifier)
        {
            modifiers.GetOrAdd(
                new Tuple<Type, string>(type, propertyName),
                _ => new List<Action<ModelMetadata>>()
            ).Add(modifier);
        }

        // This method is called by the developer to get an instance of the registrar which
        // can be used to record model-level metadata changes.
        public MetadataRegistrar<TModel> ForModel<TModel>()
        {
            return new MetadataRegistrar<TModel>(this);
        }

        // The MetadataRegistrar class is the core type that records registrations. It
        // contains methods which add actions to the provider list which modify the
        // metadata object appropriately. Because this is a fluent API, we always return
        // an instance of ourselves so that we can chain calls together.
        public class MetadataRegistrar<TModel>
        {
            FluentMetadataProvider provider;
            string propertyName;

            public MetadataRegistrar(FluentMetadataProvider provider, string propertyName = null)
            {
                this.provider = provider;
                this.propertyName = propertyName;
            }

            public MetadataRegistrar<TModel> ConvertEmptyStringToNull(bool convertEmptyStringToNull)
            {
                provider.Add(typeof(TModel), propertyName, metadata => metadata.ConvertEmptyStringToNull = convertEmptyStringToNull);
                return this;
            }

            public MetadataRegistrar<TModel> DataTypeName(string dataTypeName)
            {
                provider.Add(typeof(TModel), propertyName, metadata => metadata.DataTypeName = dataTypeName);
                return this;
            }

            public MetadataRegistrar<TModel> Description(string description)
            {
                provider.Add(typeof(TModel), propertyName, metadata => metadata.Description = description);
                return this;
            }

            public MetadataRegistrar<TModel> DisplayFormatString(string displayFormatString)
            {
                provider.Add(typeof(TModel), propertyName, metadata => metadata.DisplayFormatString = displayFormatString);
                return this;
            }

            public MetadataRegistrar<TModel> DisplayName(string displayName)
            {
                provider.Add(typeof(TModel), propertyName, metadata => metadata.DisplayName = displayName);
                return this;
            }

            public MetadataRegistrar<TModel> EditFormatString(string editFormatString)
            {
                provider.Add(typeof(TModel), propertyName, metadata => metadata.EditFormatString = editFormatString);
                return this;
            }

            public MetadataRegistrar<TModel> HideSurroundingHtml(bool hideSurroundingHtml)
            {
                provider.Add(typeof(TModel), propertyName, metadata => metadata.HideSurroundingHtml = hideSurroundingHtml);
                return this;
            }

            public MetadataRegistrar<TModel> IsReadOnly(bool isReadOnly)
            {
                provider.Add(typeof(TModel), propertyName, metadata => metadata.IsReadOnly = isReadOnly);
                return this;
            }

            public MetadataRegistrar<TModel> NullDisplayText(string nullDisplayText)
            {
                provider.Add(typeof(TModel), propertyName, metadata => metadata.NullDisplayText = nullDisplayText);
                return this;
            }

            public MetadataRegistrar<TModel> ShortDisplayName(string shortDisplayName)
            {
                provider.Add(typeof(TModel), propertyName, metadata => metadata.ShortDisplayName = shortDisplayName);
                return this;
            }

            public MetadataRegistrar<TModel> ShowForDisplay(bool showForDisplay)
            {
                provider.Add(typeof(TModel), propertyName, metadata => metadata.ShowForDisplay = showForDisplay);
                return this;
            }

            public MetadataRegistrar<TModel> ShowForEdit(bool showForEdit)
            {
                provider.Add(typeof(TModel), propertyName, metadata => metadata.ShowForEdit = showForEdit);
                return this;
            }

            public MetadataRegistrar<TModel> SimpleDisplayText(string simpleDisplayText)
            {
                provider.Add(typeof(TModel), propertyName, metadata => metadata.SimpleDisplayText = simpleDisplayText);
                return this;
            }

            public MetadataRegistrar<TModel> TemplateHint(string templateHint)
            {
                provider.Add(typeof(TModel), propertyName, metadata => metadata.TemplateHint = templateHint);
                return this;
            }

            public MetadataRegistrar<TModel> Watermark(string watermark)
            {
                provider.Add(typeof(TModel), propertyName, metadata => metadata.Watermark = watermark);
                return this;
            }

            // Support implicit conversion back to the provider, so that the user can create,
            // configure, and register the provider with a single line of code.
            public static implicit operator FluentMetadataProvider(MetadataRegistrar<TModel> registrar)
            {
                return registrar.provider;
            }

            // This method is like ForModel above, except that it lets the developer transition
            // to a new model without needing to go back to the registrar itself.
            public MetadataRegistrar<TNewModel> ForModel<TNewModel>()
            {
                return new MetadataRegistrar<TNewModel>(provider);
            }

            // This method is called by the developer to get an instance of the registrar which
            // can be used to record property-level metadata changes. We use Expression<T> here
            // so that the user can get Intellisense for the property expression, and also so
            // that their registration code can support refactoring operations like renaming
            // properties on models.
            public MetadataRegistrar<TModel> ForProperty(Expression<Func<TModel, object>> expression)
            {
                return new MetadataRegistrar<TModel>(provider, ExpressionToPropertyName(expression));
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
