using AspnetApi.Common;
using AspnetApi.Data;
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
    public class RequestApprovalController : ControllerBase
    {
        private readonly ApiDbContext _context;

        private readonly ICommonService<RequestApprove> _commonService;

        private readonly UserManager<Account> _userManager;

        private readonly IWebHostEnvironment _env;

        public RequestApprovalController(ApiDbContext dbContext, ICommonService<RequestApprove> commonService, IWebHostEnvironment env, UserManager<Account> userManager)
        {
            _context = dbContext;
            _commonService = commonService;
            _env = env;
            _userManager = userManager;
        }

        [HttpPost("search")]
        public async Task<IActionResult> GetPendingComments([FromBody] SearchRequestApproveFilter queryParams)
        {
            var includeFunc = new Func<IQueryable<RequestApprove>, IQueryable<RequestApprove>>(query =>
                query.Include(p => p.Comment).ThenInclude(pc => pc.Post).Include(p => p.Comment)
             .ThenInclude(c => c.Account)
            );

            var pagedResponse = await _commonService.SearchRequestApprove(queryParams, new[] { "" }, includeFunc);

            return Ok(pagedResponse);
        }
        [HttpGet("approve/{requestId}")]
        public async Task<IActionResult> ApproveComment(int requestId)
        {
            var request = await _context.RequestApproves
                .Include(r => r.Comment)
                .FirstOrDefaultAsync(r => r.Id == requestId);

            if (request == null || request.Status != AspnetApi.Constants.Constants.REQUEST_APPROVAL["PENDING"])
            {
                return NotFound();
            }

            request.Status = AspnetApi.Constants.Constants.REQUEST_APPROVAL["APPROVE"];
            await _context.SaveChangesAsync();

            return Ok(requestId);
        }

        [HttpGet("reject/{requestId}")]
        public async Task<IActionResult> RejectComment(int requestId)
        {
            var request = await _context.RequestApproves
                .Include(r => r.Comment)
                .FirstOrDefaultAsync(r => r.Id == requestId);

            if (request == null || request.Status != AspnetApi.Constants.Constants.REQUEST_APPROVAL["PENDING"])
            {
                return NotFound();
            }

            request.Status = AspnetApi.Constants.Constants.REQUEST_APPROVAL["REJECT"];
            await _context.SaveChangesAsync();

            return Ok(requestId);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetCommentRequestDetail(int id)
        {
            var requestDetail = await _context.RequestApproves
                .Include(r => r.Comment)       
                .ThenInclude(c => c.Post)
                .Include(r => r.Comment)
                .ThenInclude(c => c.Account)
                .Where(r => r.Id == id)   
                .FirstOrDefaultAsync();

            if (requestDetail == null)
            {
                return NotFound(new { message = "Comment request not found." });
            }

            return Ok(requestDetail);
        }
    }
}
