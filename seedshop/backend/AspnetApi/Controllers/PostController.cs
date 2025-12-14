using AspnetApi.Common;
using AspnetApi.Data;
using AspnetApi.Dtos.Product.Request;
using AspnetApi.Dtos.Product;
using AspnetApi.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Text.Json;
using AspnetApi.Dtos.Post;
using AspnetApi.Dtos.Post.Request;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Azure.Core;
using System.Net.NetworkInformation;
using System.Xml.Linq;
using AspnetApi.Dtos.Post.Response;

namespace AspnetApi.Controllers
{
    [Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
    [Route("api/[controller]")]
    [ApiController]
    public class PostController : ControllerBase
    {
        private readonly ApiDbContext _context;

        private readonly ICommonService<Post> _commonService;

        private readonly UserManager<Account> _userManager;

        public PostController(ApiDbContext dbContext, ICommonService<Post> commonService, UserManager<Account> userManager)
        {
            _context = dbContext;
            _commonService = commonService;
            _userManager = userManager;
        }
        [AllowAnonymous]
        //[Authorize(Roles = "Admin")]
        [HttpPost("search")]
        public async Task<IActionResult> Get([FromBody] SearchPostFilter queryParams)
        {
            var query = _context.Posts.AsQueryable();

            var includeFunc = new Func<IQueryable<Post>, IQueryable<Post>>(query =>
               query.Include(p => p.PostCategory)
           );

            var pagedResponse = await _commonService.SearchPost(queryParams, new[] { "Title" }, includeFunc);

            return Ok(pagedResponse);
        }
        [AllowAnonymous]
        //[Authorize(Roles = "Admin")]
        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            /*    Post? item = await _context.Posts.FirstOrDefaultAsync(t => t.Id == id);
                var query = from post in _context.Posts
                            join postCategory in _context.PostCategories on post.PostCategoryId equals postCategory.Id
                            join comment in _context.Comments on post.Id equals comment.PostId into postComments
                            from comment in postComments.DefaultIfEmpty()
                            join requestApprove in _context.RequestApproves on comment.Id equals requestApprove.CommentId into commentApprovals
                            from requestApprove in commentApprovals.DefaultIfEmpty()
                            join account in _context.Users on comment.AccountId equals account.Id into accounts
                            from account in accounts.DefaultIfEmpty()
                            where post.Id == id && (requestApprove == null || requestApprove.Status == AspnetApi.Constants.Constants.REQUEST_APPROVAL["APPROVE"])
                            select new
                            {
                                Post = post,
                                PostCategoryName = postCategory.PostCategoryName,
                                Comments = comment,
                                Account = account,
                                RequestApprove = requestApprove,
                            };

                var postDetails = await query.ToListAsync();


                var result = postDetails
                  .GroupBy(x => new { x.Post, x.PostCategoryName })
                  .Select(g => new PostDetailResponse
                  {
                      Post = g.Key.Post,
                      PostCategoryName = g.Key.PostCategoryName,
                      Comments = g
                          .Where(x => x.Comments != null)
                          .Select(x => new Comment
                          {
                              Id = x.Comments.Id,
                              Post = x.Comments.Post,
                              PostId = x.Comments.PostId,
                              AccountId = x.Comments.AccountId,
                              Content = x.Comments.Content,
                              CreatedAt = x.Comments.CreatedAt,
                              Account = x.Account
                          })
                          .ToList()
                  })
                  .FirstOrDefault();


                if (item == null)
                {
                    return new JsonResult("Post id Not found") { StatusCode = 400 };
                }

                return Ok(result);*/
            var item = await _context.Posts
        .FirstOrDefaultAsync(t => t.Id == id);

            if (item == null)
            {
                return new JsonResult("Post id Not found") { StatusCode = 400 };
            }

            // Fetch post details separately
            var postDetailsQuery = from post in _context.Posts
                                   join postCategory in _context.PostCategories
                                       on post.PostCategoryId equals postCategory.Id
                                   where post.Id == id
                                   select new
                                   {
                                       Post = post,
                                       PostCategoryName = postCategory.PostCategoryName
                                   };

            var postDetails = await postDetailsQuery.FirstOrDefaultAsync();

            // Fetch comments separately to avoid complex joins
            var commentsQuery = from comment in _context.Comments
                                where comment.PostId == id
                                join requestApprove in _context.RequestApproves
                                    on comment.Id equals requestApprove.CommentId into commentApprovals
                                from requestApprove in commentApprovals.DefaultIfEmpty()
                                join account in _context.Users
                                    on comment.AccountId equals account.Id into accounts
                                from account in accounts.DefaultIfEmpty()
                                where requestApprove == null || requestApprove.Status == AspnetApi.Constants.Constants.REQUEST_APPROVAL["APPROVE"]
                                select new Comment
                                {
                                    Id = comment.Id,
                                    PostId = comment.PostId,
                                    AccountId = comment.AccountId,
                                    Content = comment.Content,
                                    CreatedAt = comment.CreatedAt,
                                    Account = account
                                };

            var comments = await commentsQuery.ToListAsync();

            // Build the final result object
            var result = new PostDetailResponse
            {
                Post = postDetails?.Post,
                PostCategoryName = postDetails?.PostCategoryName,
                Comments = comments
            };

            return Ok(result);

        }

        [Authorize(Roles = "Admin")]
        [HttpPost]
        public async Task<IActionResult> Add([FromForm] CreatePostDTO post)
        {
            var checkExist = await _context.Posts.FirstOrDefaultAsync(ct => ct.Title.Equals(post.Title));

            if (checkExist != null)
            {
                return new JsonResult("Post name is existed") { StatusCode = 400 };
            }

            //upload image
            string json = "";
            var imageProduct = await _commonService.UploadFile(post.Image);
         

            if (!post.Equals(null))
            {
                Post item = new Post()
                {
                    Title = post.Title,
                    Description = post.Description,
                    Content = post.Content,
                    PostCategory = await _context.PostCategories.FindAsync(post.PostCategoryId),
                    //STATUS = DRAFF, UNPUBLISH, PUBLISH
                    Status = post.Status,
                    Image = imageProduct,
                    Slug = SlugHelper.GenerateSlug(post.Title),
                };

                await _context.Posts.AddAsync(item);
                await _context.SaveChangesAsync();

               
                return CreatedAtAction("GetById", new { item.Id }, post);
            }

            return new JsonResult("Something went wrong") { StatusCode = 500 };
        }
      
        [Authorize(Roles = "Admin")]
        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, [FromForm] UpdatePostDTO post)
        {
            Post? exist = await _context.Posts.FirstOrDefaultAsync(t => t.Id == id);


            if (exist == null)
            {
                throw new ArgumentException($"Post with ID: {id} not found");
            }
          
            var imageProduct = await _commonService.UploadFile(post.Image);

           
            if (ModelState.IsValid)
            {
                exist.Title = post.Title;
                exist.Description = post.Description;
                exist.Status = post.Status;
                exist.PostCategory = await _context.PostCategories.FindAsync(post.PostCategoryId);
                exist.Content = post.Content;
                exist.Slug = SlugHelper.GenerateSlug(post.Title);
                if (imageProduct != null && imageProduct.Length > 0)
                {
                    exist.Image = imageProduct;
                }
              
                await _context.SaveChangesAsync();
                return Ok(exist);
            }

            return new JsonResult("Something went wrong") { StatusCode = 500 };
        }

        [Authorize(Roles = "Admin")]
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            Post? exist = await _context.Posts.FirstOrDefaultAsync(t => t.Id == id);

            if (exist.Equals(null)) throw new ArgumentException($"Post with ID: {id} not found");

            if (ModelState.IsValid)
            {
                _context.Remove(exist);
                await _context.SaveChangesAsync();

                return Ok(exist);
            }
            return new JsonResult("Something went wrong") { StatusCode = 500 };

        }
    }
}
