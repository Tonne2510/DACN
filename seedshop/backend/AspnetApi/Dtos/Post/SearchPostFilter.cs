using JwtToken.Dtos;

namespace AspnetApi.Dtos.Post
{
    public class SearchPostFilter:QueryParams
    {
        public string? PostCategoryId { get; set; }
        public string? IsPublish {  get; set; }
    }
}
