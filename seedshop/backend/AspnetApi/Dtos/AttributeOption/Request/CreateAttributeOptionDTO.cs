using System.ComponentModel.DataAnnotations;

namespace AspnetApi.Dtos.AttributeOption.Request
{
    public class CreateAttributeOptionDTO
    {
        [Required]
        public string OptionName { get; set; }
        [Required]
        public int AttributeId { get; set; }
    }
}
