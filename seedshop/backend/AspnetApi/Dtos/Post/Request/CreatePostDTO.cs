using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace AspnetApi.Dtos.Post.Request
{
    public class CreatePostDTO
    {
        [Required]
        [StringLength(200)]
        public string Title { get; set; }

        public string? Description { get; set; }

        public int PostCategoryId { get; set; }

        [Required]
        public string Content { get; set; }

        public string? Status { get; set; }

        public IFormFile? Image { get; set; }
    }
}
