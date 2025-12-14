using AspnetApi.Constants;
using AspnetApi.Data;
using AspnetApi.Dtos.Account;
using AspnetApi.Dtos.Comment;
using AspnetApi.Dtos.Post;
using AspnetApi.Dtos.Product;
using AspnetApi.Dtos.RequestApprove;
using AspnetApi.Models;
using JwtToken.Dtos;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.EntityFrameworkCore;
using System.Linq.Expressions;
using System.Reflection.Metadata;


namespace AspnetApi.Common
{
    public class CommonService<T> : ICommonService<T> where T : class
    {
        private readonly ApiDbContext _context;
        private readonly DbSet<T> _dbSet;

        public CommonService(ApiDbContext context)
        {
            _context = context;
            _dbSet = _context.Set<T>();
        }

        public async Task<PagedResponse<T>> GetPagedDataAsync(QueryParams queryParams, string[] filterBy, Func<IQueryable<T>, IQueryable<T>> includeFunc = null)
        {
            var query = await GetQuery(queryParams, filterBy);

            // Get total records
            var totalRecords = await query.CountAsync();

            if (includeFunc != null)
            {
                query = includeFunc(query);
            }

            // Apply pagination
            var items = await query
                .Skip((queryParams.PageNumber - 1) * queryParams.PageSize)
                .Take(queryParams.PageSize)
                .ToListAsync();

            // Create and return paginated response
            return new PagedResponse<T>(items, totalRecords, queryParams.PageNumber, queryParams.PageSize);
        }

        public  async Task<string> UploadFile(IFormFile? uploadFile)
        {
            var uniqueFileName = "";
            if (uploadFile != null && uploadFile.Length > 0)
            {
                uniqueFileName = Guid.NewGuid().ToString() + Path.GetExtension(uploadFile.FileName);
                var filePath = Path.Combine(Constants.Constants.ROOT_IMAGE, uniqueFileName);

                using (var stream = new FileStream(filePath, FileMode.Create))
                {
                    await uploadFile.CopyToAsync(stream);
                }

            }
            else
            {
                return null;
            }
            return uniqueFileName;
        }

        public async Task<List<string>> UploadFiles(List<IFormFile> files)
        {
            var savedFileNames = new List<string>();

            foreach (var file in files)
            {
                if (file.Length > 0)
                {
                    // Generate a unique file name to avoid collisions
                    var uniqueFileName = Guid.NewGuid().ToString() + Path.GetExtension(file.FileName);
                    var filePath = Path.Combine(Constants.Constants.ROOT_IMAGE, uniqueFileName);

                    // Save the file
                    using (var stream = new FileStream(filePath, FileMode.Create))
                    {
                        await file.CopyToAsync(stream);
                    }

                    savedFileNames.Add(uniqueFileName);
                }
            }

            return savedFileNames;
        }

        private static IQueryable<T> ApplyFilter(IQueryable<T> query, string[] propertyNames, string keyword)
        {
            if (propertyNames.Length <= 0 || string.IsNullOrEmpty(keyword))
            {
                return query;
            }

            var parameter = Expression.Parameter(typeof(T), "item");


            var expressions = new List<Expression>();

            foreach (var propertyName in propertyNames)
            {
                var property = Expression.Property(parameter, propertyName);
                var containsMethod = typeof(string).GetMethod("Contains", new[] { typeof(string) });
                var searchValue = Expression.Constant(keyword, typeof(string));
                var propertyExpression = Expression.Call(property, containsMethod, searchValue);

                expressions.Add(propertyExpression);
            }

            // Combine all expressions with OR
            Expression combinedExpression = expressions
            .Aggregate<Expression>((left, right) => Expression.OrElse(left, right));

            var lambda = Expression.Lambda<Func<T, bool>>(combinedExpression, parameter);

            return query.Where(lambda);
        }

        public async Task<PagedResponse<T>> SearchAccount(SearchAccountFilter queryParams, string[] filterBy)
        {
            var query =await GetQuery(queryParams, filterBy);
            var roleId = queryParams.RoleId;
            

            if (!string.IsNullOrWhiteSpace(roleId) && typeof(T) == typeof(Account))
            {
                var accountQuery = query.Cast<Account>();

             
                accountQuery = accountQuery
                    .Join(_context.UserRoles, 
                          account => account.Id,  
                          userRole => userRole.UserId,
                          (account, userRole) => new { account, userRole })  
                    .Join(_context.Roles,  
                          combined => combined.userRole.RoleId,  
                          role => role.Id,  // Match on Role Id
                          (combined, role) => combined.account) 
                    .Where(account => _context.UserRoles.Any(ur => ur.RoleId == roleId && ur.UserId == account.Id)); // Filter accounts by RoleId

               
                query = accountQuery.Cast<T>();
            }


            int totalRecords = await query.CountAsync();
            var items = await query
               .Skip((queryParams.PageNumber - 1) * queryParams.PageSize)
               .Take(queryParams.PageSize)
               .ToListAsync();

            // Create and return paginated response
            return new PagedResponse<T>(items, totalRecords, queryParams.PageNumber, queryParams.PageSize);
        }

        private async Task<IQueryable<T>> GetQuery(QueryParams queryParams, string[] filterBy)
        {
            var query = _dbSet.AsQueryable();

            // Apply filtering
            if (!string.IsNullOrEmpty(queryParams.Keyword))
            {
                query = ApplyFilter(query, filterBy, queryParams.Keyword);
            }

            if (!string.IsNullOrEmpty(queryParams.Status))
            {
                bool status = queryParams.Status.Equals("1");
                query = query.Where(item => EF.Property<bool>(item, "Active") == status);
            }

            // Apply sorting
            if (!string.IsNullOrEmpty(queryParams.SortBy) && !string.IsNullOrEmpty(queryParams.SortDir))
            {
                query = SortHelper.ApplySorting(query, queryParams.SortBy, string.Equals(queryParams.SortDir, "asc", StringComparison.OrdinalIgnoreCase));
            }else
            {
                query = SortHelper.ApplySorting(query, "CreatedAt", string.Equals("desc", "asc", StringComparison.OrdinalIgnoreCase));
            }

            return query;
        }

        public async Task<PagedResponse<T>> SearchProduct(SearchProductFilter queryParams, string[] filterBy, Func<IQueryable<T>, IQueryable<T>> includeFunc = null)
        {
            var query = await GetQuery(queryParams, filterBy);


            // Apply filtering by categoryId
            if (!string.IsNullOrEmpty(queryParams.CategoryId))
            {
                query = query.Where(p => EF.Property<string>(p, "CategoryId") == queryParams.CategoryId);
            }

            if (queryParams.FromPrice.HasValue)
            {
                query = query.Where(p => EF.Property<decimal>(p, "Price") >= queryParams.FromPrice.Value);
            }

            if (queryParams.ToPrice.HasValue && queryParams.ToPrice.Value!=0)
            {
                query = query.Where(p => EF.Property<decimal>(p, "Price") <= queryParams.ToPrice.Value);
            }

            if (queryParams.OptionIds != null && queryParams.OptionIds.Any())
            {
                var accountQuery = query.Cast<Product>();

                accountQuery = accountQuery
                        .Join(_context.AttributeOptionProducts,
                            product => product.Id,
                            attributeOption => attributeOption.ProductId,
                            (product, attributeOption) => new { product, attributeOption }) 
                        .Where(combined => queryParams.OptionIds.Contains(combined.attributeOption.AttributeOptionId))  // Filter by OptionIds
                        .Select(combined => combined.product);


                query = accountQuery.Cast<T>();
            }

            // Get total records
            var totalRecords = await query.CountAsync();

            if (includeFunc != null)
            {
                query = includeFunc(query);
            }

            // Apply pagination
            var items = await query
                .Skip((queryParams.PageNumber - 1) * queryParams.PageSize)
                .Take(queryParams.PageSize)
                .ToListAsync();

            // Create and return paginated response
            return new PagedResponse<T>(items, totalRecords, queryParams.PageNumber, queryParams.PageSize);
        }

        public async Task<PagedResponse<T>> SearchPost(SearchPostFilter queryParams, string[] filterBy, Func<IQueryable<T>, IQueryable<T>> includeFunc = null)
        {
            var query = await GetQuery(queryParams, filterBy);


            // Apply filtering by categoryId
            if (!string.IsNullOrEmpty(queryParams.PostCategoryId))
            {
                query = query.Where(p => EF.Property<string>(p, "PostCategoryId") == queryParams.PostCategoryId);
            }

            if (!string.IsNullOrEmpty(queryParams.IsPublish))
            {
                query = query.Where(p => EF.Property<string>(p, "Status") == queryParams.IsPublish);
            }

            query = query.Where(p => EF.Property<string>(p, "Status") != "DRAFT");

            // Get total records
            var totalRecords = await query.CountAsync();

            if (includeFunc != null)
            {
                query = includeFunc(query);
            }

            // Apply pagination
            var items = await query
                .Skip((queryParams.PageNumber - 1) * queryParams.PageSize)
                .Take(queryParams.PageSize)
                .ToListAsync();

            // Create and return paginated response
            return new PagedResponse<T>(items, totalRecords, queryParams.PageNumber, queryParams.PageSize);
        }

        public async Task<PagedResponse<T>> SearchRequestApprove(SearchRequestApproveFilter queryParams, string[] filterBy, Func<IQueryable<T>, IQueryable<T>> includeFunc = null)
        {
            var query = await GetQuery(queryParams, filterBy);

            query = query.Where(p => EF.Property<string>(p, "Status") == AspnetApi.Constants.Constants.REQUEST_APPROVAL["PENDING"]);


            if (queryParams.StartDate!=null&& queryParams.StartDate.HasValue)
            {
                query = query.Where(p => EF.Property<DateTime>(p, "CreatedAt") >= queryParams.StartDate);

            }

            if (queryParams.EndDate != null && queryParams.EndDate.HasValue)
            {
                query = query.Where(p => EF.Property<DateTime>(p, "CreatedAt") <= queryParams.EndDate);
            }


            // Get total records
            var totalRecords = await query.CountAsync();

            if (includeFunc != null)
            {
                query = includeFunc(query);
            }

            // Apply pagination
            var items = await query
                .Skip((queryParams.PageNumber - 1) * queryParams.PageSize)
                .Take(queryParams.PageSize)
                .ToListAsync();

            // Create and return paginated response
            return new PagedResponse<T>(items, totalRecords, queryParams.PageNumber, queryParams.PageSize);
        
        }

        public async Task<PagedResponse<T>> SearchComment(SearchCommentFilter queryParams, string[] filterBy, Func<IQueryable<T>, IQueryable<T>> includeFunc = null)
        {
            var query = await GetQuery(queryParams, filterBy);

            if (!string.IsNullOrEmpty(queryParams.IsActive))
            {
                var commentQuery = query.Cast<Comment>();

                commentQuery = commentQuery
                  .Join(_context.RequestApproves,
                        comment => comment.Id,
                        requestApprove => requestApprove.CommentId,
                        (comment, requestApprove) => new { comment, requestApprove })
                  .Where(cmt => cmt.requestApprove.Status == queryParams.IsActive)
                  .Select(cmt => cmt.comment);

                query = commentQuery.Cast<T>();

            }else
            {
                var commentQuery = query.Cast<Comment>();

                commentQuery = commentQuery
                  .Join(_context.RequestApproves,
                        comment => comment.Id,
                        requestApprove => requestApprove.CommentId,
                        (comment, requestApprove) => new { comment, requestApprove })
                  .Where(cmt => cmt.requestApprove.Status == AspnetApi.Constants.Constants.REQUEST_APPROVAL["APPROVE"])
                  .Select(cmt => cmt.comment);

                query = commentQuery.Cast<T>();
            }


            if (queryParams.StartDate != null && queryParams.StartDate.HasValue)
            {
                query = query.Where(p => EF.Property<DateTime>(p, "CreatedAt").Date >= queryParams.StartDate);

            }

            if (queryParams.EndDate != null && queryParams.EndDate.HasValue)
            {
                query = query.Where(p => EF.Property<DateTime>(p, "CreatedAt").Date <= queryParams.EndDate);
            }

            // Get total records
            var totalRecords = await query.CountAsync();

            if (includeFunc != null)
            {
                query = includeFunc(query);
            }

            // Apply pagination
            var items = await query
                .Skip((queryParams.PageNumber - 1) * queryParams.PageSize)
                .Take(queryParams.PageSize)
                .ToListAsync();

            // Create and return paginated response
            return new PagedResponse<T>(items, totalRecords, queryParams.PageNumber, queryParams.PageSize);

        }
    }
}
