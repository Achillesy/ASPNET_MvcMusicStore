using System.ComponentModel.DataAnnotations;

namespace $rootnamespace$.Areas.FluentValidation.Models
{
    public class Contact
    {
        [Display(Name = "First Name")]
        public string FirstName { get; set; }

        [Display(Name = "Last Name")]
        public string LastName { get; set; }

        [Display(Name = "E-mail Address")]
        public string EmailAddress { get; set; }
    }
}