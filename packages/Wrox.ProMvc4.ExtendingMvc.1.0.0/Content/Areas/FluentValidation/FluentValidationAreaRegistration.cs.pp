using System.Web.Mvc;
using $rootnamespace$.Areas.FluentValidation.Models;
using $rootnamespace$.Areas.FluentValidation.Utility;

namespace $rootnamespace$.Areas.FluentValidation
{
    public class FluentValidationAreaRegistration : AreaRegistration
    {
        public override string AreaName
        {
            get
            {
                return "FluentValidation";
            }
        }

        public override void RegisterArea(AreaRegistrationContext context)
        {
            context.MapRoute(
                "FluentValidation_default",
                "FluentValidation/{action}/{id}",
                new { controller = "FluentValidation", action = "Index", id = UrlParameter.Optional }
            );

            ModelValidatorProviders.Providers.Add(
                new FluentValidationProvider()
                    .ForModel<Contact>()
                        .ForProperty(c => c.FirstName)
                            .Required()
                            .StringLength(maxLength: 15)
                        .ForProperty(c => c.LastName)
                            .Required(errorMessage: "You absolutely must provide the last name!")
                            .StringLength(minLength: 3, maxLength: 20)
                        .ForProperty(c => c.EmailAddress)
                            .Required()
                            .StringLength(minLength: 10)
                            .EmailAddress()
            );
        }
    }
}
