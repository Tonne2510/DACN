using JwtToken.Dtos;

namespace AspnetApi.Dtos.Product
{
    public class SearchProductFilter:QueryParams
    {
        public decimal? FromPrice {  get; set; }
        public decimal? ToPrice { get; set; }
        public string? CategoryId { get; set; }
        public int[]? OptionIds { get; set; }
       
    }
}
