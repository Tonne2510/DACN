using AspnetApi.Common;
using AspnetApi.Data;
using AspnetApi.Dtos.Account;
using AspnetApi.Dtos.Comment;
using AspnetApi.Dtos.RequestApprove;
using AspnetApi.Models;
using JwtToken.Dtos;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace AspnetApi.Controllers
{
    [Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
    [Route("api/[controller]")]
    [ApiController]
    public class CommentController : ControllerBase
    {
        private readonly ApiDbContext _context;

        private readonly ICommonService<Comment> _commonService;

        private readonly UserManager<Account> _userManager;

        private readonly IWebHostEnvironment _env;

        public CommentController(ApiDbContext dbContext, ICommonService<Comment> commonService, IWebHostEnvironment env, UserManager<Account> userManager)
        {
            _context = dbContext;
            _commonService = commonService;
            _env = env;
            _userManager = userManager;
        }

        public async Task<IActionResult> CreateComment(Comment comment)
        {
            _context.Comments.Add(comment);
            await _context.SaveChangesAsync();

            var approvalRequest = new RequestApprove
            {
                CommentId = comment.Id,
                Status = AspnetApi.Constants.Constants.REQUEST_APPROVAL["PENDING"]
            };

            _context.RequestApproves.Add(approvalRequest);
            await _context.SaveChangesAsync();
            var response = new { message = "Thêm mới thành công" };
            return Ok(response);
        }

        [Authorize(Roles = "Admin")]
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            Comment? exist = await _context.Comments.FirstOrDefaultAsync(t => t.Id == id);

            if (exist.Equals(null)) throw new ArgumentException($"Post Category with ID: {id} not found");

            if (ModelState.IsValid)
            {
                _context.Remove(exist);
                await _context.SaveChangesAsync();

                return Ok(exist);
            }
            return new JsonResult("Something went wrong") { StatusCode = 500 };

        }

        //lấy tất comment lọc theo bài viết từ ngày nào-> đến ngày nào. status approve,reject
        //thực hiện schedualer sau 1 tháng sẽ tự xóa những cái comment cs status là: reject
        [HttpPost("search")]
        public async Task<IActionResult> GetComments([FromBody] SearchCommentFilter queryParams)
        {
            var includeFunc = new Func<IQueryable<Comment>, IQueryable<Comment>>(query =>
                query.Include(p => p.Post).Include(pc=>pc.Account)
            );

            var pagedResponse = await _commonService.SearchComment(queryParams, new[] { "" }, includeFunc);

            return Ok(pagedResponse);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetCommentDetail(int id)
        {
            var detail = await _context.Comments
                .Include(r => r.Account)
                .Include(r => r.Post)
                .Where(r => r.Id == id)
                .FirstOrDefaultAsync();

            if (detail == null)
            {
                return NotFound(new { message = "Comment not found." });
            }

            return Ok(detail);
        }
    }
}
