using System.ComponentModel.DataAnnotations;

namespace AspnetApi.Dtos.Category.Request
{
    public class UpdateCategoryDTO
    {
        public string Active { get; set; }

        [Required]
        [MaxLength(255)]
        public string CategoryName { get; set; }
    }
}
