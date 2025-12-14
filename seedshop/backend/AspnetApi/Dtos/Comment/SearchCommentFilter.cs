using AspnetApi.Utils;
using JwtToken.Dtos;
using System.Text.Json.Serialization;

namespace AspnetApi.Dtos.Comment
{
    public class SearchCommentFilter:QueryParams
    {
        [JsonConverter(typeof(CustomConverter))]
        public DateTime? StartDate { get; set; }

        [JsonConverter(typeof(CustomConverter))]
        public DateTime? EndDate { get; set; }

        public string? IsActive { get; set; }
    }
}
