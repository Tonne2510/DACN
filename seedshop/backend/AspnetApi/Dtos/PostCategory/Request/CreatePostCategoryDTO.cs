using System.ComponentModel.DataAnnotations;

namespace AspnetApi.Dtos.PostCategory.Request
{
    public class CreatePostCategoryDTO
    {
        public string Active { get; set; }

        [Required]
        [MaxLength(255)]
        public string PostCategoryName { get; set; }
    }
}
