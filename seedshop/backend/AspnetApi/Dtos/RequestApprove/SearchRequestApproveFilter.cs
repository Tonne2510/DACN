using AspnetApi.Utils;
using JwtToken.Dtos;
using System.Text.Json.Serialization;

namespace AspnetApi.Dtos.RequestApprove
{
    public class SearchRequestApproveFilter:QueryParams
    {
        [JsonConverter(typeof(CustomConverter))]
        public DateTime? StartDate { get; set; }

        [JsonConverter(typeof(CustomConverter))]
        public DateTime? EndDate { get; set; }
    }
}
