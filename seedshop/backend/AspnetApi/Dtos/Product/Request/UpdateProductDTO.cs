using System.ComponentModel.DataAnnotations;

namespace AspnetApi.Dtos.Product.Request
{
    public class UpdateProductDTO
    {
        public float Price { get; set; }

        public float SalePrice { get; set; } = 0;

        public string? Active { get; set; }

        public IFormFile? Image { get; set; }

        [Required]
        public string ProductName { get; set; }

        public string? Description { get; set; }

        public int CategoryId { get; set; }

        public List<IFormFile>? Album { get; set; }

        public string? OldImage { get; set; }

    }
}
