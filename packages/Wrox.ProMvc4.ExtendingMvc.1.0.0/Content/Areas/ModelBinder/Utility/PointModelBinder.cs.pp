using System;
using System.Collections.Generic;
using System.Drawing;
using System.Web.Mvc;

namespace $rootnamespace$.Areas.ModelBinder.Utility
{
    public class PointModelBinder : IModelBinder
    {
        public object BindModel(ControllerContext controllerContext,
                                ModelBindingContext bindingContext)
        {
            // We first attempt to find values based on the model name, and if we can't find
            // anything for the model name, we'll fall back to the empty prefix as appropriate.

            if (!String.IsNullOrEmpty(bindingContext.ModelName) &&
                !bindingContext.ValueProvider.ContainsPrefix(bindingContext.ModelName))
            {
                if (!bindingContext.FallbackToEmptyPrefix)
                    return null;

                bindingContext = new ModelBindingContext
                {
                    ModelMetadata = bindingContext.ModelMetadata,
                    ModelState = bindingContext.ModelState,
                    PropertyFilter = bindingContext.PropertyFilter,
                    ValueProvider = bindingContext.ValueProvider
                };
            }

            // We have to create a new model, because Point is immutable. When the type
            // isn't immutable, we can always take in the existing object, when one exists,
            // and update it instead. The existing object, if one exists, is available
            // via bindingContext.Model. Instead, we'll put a temporary (empty) object into
            // the binding context so that validation can succeed while we validate all
            // the parameter values.

            bindingContext.ModelMetadata.Model = new Point();

            return new Point(
                Get<int>(controllerContext, bindingContext, "X"),
                Get<int>(controllerContext, bindingContext, "Y")
            );
        }

        private TModel Get<TModel>(ControllerContext controllerContext,
                                    ModelBindingContext bindingContext,
                                    string name)
        {
            // Get the fully qualified name, because model state needs to use that, and not just
            // the simple property name.
            string fullName = name;
            if (!String.IsNullOrWhiteSpace(bindingContext.ModelName))
                fullName = bindingContext.ModelName + "." + name;

            // Get the value from the value provider
            ValueProviderResult valueProviderResult = bindingContext.ValueProvider.GetValue(fullName);

            // Add the attempted value to model state, so that we can round-trip their
            // value even when it's incorrect and incapable of being held inside the
            // model itself (i.e., the user types "abc" for an int).
            ModelState modelState = new ModelState { Value = valueProviderResult };
            bindingContext.ModelState.Add(fullName, modelState);

            // Get the ModelMetadata that represents this property, as we use several of its
            // values, and it's necessary for validation
            ModelMetadata metadata = bindingContext.PropertyMetadata[name];

            // Convert the attempted value to null automatically
            string attemptedValue = valueProviderResult.AttemptedValue;
            if (metadata.ConvertEmptyStringToNull && String.IsNullOrWhiteSpace(attemptedValue))
                attemptedValue = null;

            TModel model;
            bool invalidValue = false;

            try
            {
                // Attempt to convert the value to the correct type
                model = (TModel)valueProviderResult.ConvertTo(typeof(TModel));
                metadata.Model = model;
            }
            catch (Exception)
            {
                // Conversion failed, so give back the default value for the type
                // and set the attempted value into model metadata
                model = default(TModel);
                metadata.Model = attemptedValue;
                invalidValue = true;
            }

            // Run the validators for the given property
            IEnumerable<ModelValidator> validators = ModelValidatorProviders.Providers.GetValidators(metadata, controllerContext);
            foreach (var validator in validators)
                foreach (var validatorResult in validator.Validate(bindingContext.Model))
                    modelState.Errors.Add(validatorResult.Message);

            // Only add the "invalid value" message if there were no other errors, because things like
            // required validation should trump conversion failures, and null/empty values will often
            // fail both required validation and type-conversion validation
            if (invalidValue && modelState.Errors.Count == 0)
                modelState.Errors.Add(
                    String.Format(
                        "The value '{0}' is not a valid value for {1}.",
                        attemptedValue,
                        metadata.GetDisplayName()
                    )
                );

            return model;
        }
    }
}
