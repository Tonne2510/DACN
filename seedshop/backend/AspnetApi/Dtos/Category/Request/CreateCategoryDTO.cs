using System.ComponentModel.DataAnnotations;

namespace AspnetApi.Dtos.Category.Request
{
    public class CategoryDTO
    {
        public string Active { get; set; }

        [Required]
        [MaxLength(255)]
        public string CategoryName { get; set; }
    }
}
