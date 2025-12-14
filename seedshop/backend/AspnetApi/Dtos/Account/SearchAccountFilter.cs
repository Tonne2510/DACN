using JwtToken.Dtos;

namespace AspnetApi.Dtos.Account
{
    public class SearchAccountFilter: QueryParams
    {
        public string? RoleId { get; set; }
    }
}
