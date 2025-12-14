using AspnetApi.Dtos.Account;
using AspnetApi.Dtos.Comment;
using AspnetApi.Dtos.Post;
using AspnetApi.Dtos.Product;
using AspnetApi.Dtos.RequestApprove;
using JwtToken.Dtos;

namespace AspnetApi.Common
{
    public interface ICommonService<T> where T : class
    {
        Task<PagedResponse<T>> GetPagedDataAsync(QueryParams queryParams, string[] filterBy, Func<IQueryable<T>, IQueryable<T>> includeFunc=null);
        Task<PagedResponse<T>> SearchAccount(SearchAccountFilter queryParams, string[] filterBy);

        Task<PagedResponse<T>> SearchProduct(SearchProductFilter queryParams, string[] filterBy, Func<IQueryable<T>, IQueryable<T>> includeFunc = null);
        Task<PagedResponse<T>> SearchPost(SearchPostFilter queryParams, string[] filterBy, Func<IQueryable<T>, IQueryable<T>> includeFunc = null);
        Task<PagedResponse<T>> SearchRequestApprove(SearchRequestApproveFilter queryParams, string[] filterBy, Func<IQueryable<T>, IQueryable<T>> includeFunc = null);
        Task<PagedResponse<T>> SearchComment(SearchCommentFilter queryParams, string[] filterBy, Func<IQueryable<T>, IQueryable<T>> includeFunc = null);
        
        Task<string> UploadFile(IFormFile? uploadFile);
        Task<List<string>> UploadFiles(List<IFormFile> files);

    }
}
