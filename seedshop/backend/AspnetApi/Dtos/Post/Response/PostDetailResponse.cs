using AspnetApi.Models;

namespace AspnetApi.Dtos.Post.Response
{
    public class PostDetailResponse
    {
       public AspnetApi.Models.Post Post { get; set; }
        public List<AspnetApi.Models.Comment>? Comments { get; set; }
        public string? PostCategoryName { get; set; }

    }
}
