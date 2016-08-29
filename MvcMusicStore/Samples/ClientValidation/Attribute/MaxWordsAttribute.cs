using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Web.Mvc;

namespace MvcMusicStore.Samples
{
    public class MaxWordsAttribute : ValidationAttribute, 
                                     IClientValidatable
    {
        public MaxWordsAttribute(int wordCount)
            :base("Too many words in {0}")
        {
            WordCount = wordCount;           
        }

        public int WordCount { get; set; }

        protected override ValidationResult IsValid(
            object value, 
            ValidationContext validationContext)
        {
            if (value != null)
            {
                var wordCount = value.ToString().Split(' ').Length;
                if (wordCount > WordCount)
                {
                    return new ValidationResult(
                        FormatErrorMessage(validationContext.DisplayName)
                    );
                }
            }
            return ValidationResult.Success;
        }

        public IEnumerable<ModelClientValidationRule> GetClientValidationRules(
            ModelMetadata metadata, ControllerContext context)
        {
            var rule = new ModelClientValidationRule();
            rule.ErrorMessage = FormatErrorMessage(metadata.GetDisplayName());
            rule.ValidationParameters.Add("wordcount", WordCount);
            rule.ValidationType = "maxwords";
            yield return rule;
        }
    }
}
