using System.ComponentModel.DataAnnotations;

namespace AspnetApi.Dtos.Attribute.Request
{
    public class UpdateAttributeDTO
    {
        [MaxLength(200)]
        [Required]
        public string AttributeCode { get; set; }

        [Required]
        public string AttributeName { get; set; }
    }
}
