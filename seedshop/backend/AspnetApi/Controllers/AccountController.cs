using AspnetApi.Common;
using AspnetApi.Data;
using AspnetApi.Dtos.Account;
using AspnetApi.Dtos.Account.Request;
using AspnetApi.Models;
using JwtToken.Dtos;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace AspnetApi.Controllers
{
    [Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
    [Route("api/[controller]")]
    [ApiController]
    public class AccountController : ControllerBase
    {
        private readonly ApiDbContext _context;

        private readonly ICommonService<Account> _commonService;

        private readonly UserManager<Account> _userManager;

        private readonly IWebHostEnvironment _env;

        public AccountController(ApiDbContext dbContext, ICommonService<Account> commonService, IWebHostEnvironment env,UserManager<Account> userManager)
        {
            _context = dbContext;
            _commonService = commonService;
            _env = env;
            _userManager = userManager;
        }

        [Authorize(Roles = "Admin")]
        [HttpPost("search")]
        public async Task<IActionResult> Get([FromBody] SearchAccountFilter queryParams)
        {
            var query = _context.Users.AsQueryable();

            var pagedResponse = await _commonService.SearchAccount(queryParams, new[] { "Username", "Email" });

            return Ok(pagedResponse);
        }

        [AllowAnonymous]
        //[Authorize(Roles = "Admin")]
        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(string id)
        {
            // Account? item = await _context.Users.FirstOrDefaultAsync(t => t.Id.Equals(id));
            var item = await _context.Users
                 .Where(u => u.Id.Equals(id))
                 .Select(u => new
                 {
                     u.Id,
                     u.UserName,
                     u.Email,
                     u.PhoneNumber,
                     u.Address,
                     u.Gender,
                     u.Avatar,
                     u.PasswordHash,
                     RoleName = _context.UserRoles
                                     .Where(ur => ur.UserId == u.Id)
                                     .Join(_context.Roles,
                                           ur => ur.RoleId,
                                           r => r.Id,
                                           (ur, r) => r.Id)
                                     .FirstOrDefault()
                 })
                 .FirstOrDefaultAsync();
            if (item == null)
            {
                return new JsonResult("Account id Not found") { StatusCode = 400 };
            }

            return Ok(item);

        }

        [Authorize(Roles = "Admin")]
        [HttpPost]
        public async Task<IActionResult> Add([FromForm] CreateAccountDTO acc)
        {
            var checkExist = await _context.Users.FirstOrDefaultAsync(ct => ct.Email.Equals(acc.Email) );
            if (checkExist != null)
            {
                return new JsonResult("Email is existed") { StatusCode = 400 };
            }
            //upload image
            var avatar = await _commonService.UploadFile(acc.Avatar);

            if (!acc.Equals(null))
            {
                Account item = new Account()
                {
                    Email = acc.Email,
                    UserName = acc.Username,
                    PhoneNumber = acc.Phone,
                    Address = acc.Address,
                    Gender = acc.Gender!=null?(acc.Gender.Equals("1") ? true : false):false,
                    Avatar = avatar
                };
                IdentityResult? result= await _userManager.CreateAsync(item, acc.Password);
                var roleName = await _context.Roles.FindAsync(acc.Role);
                if (result.Succeeded)
                {
                   
                    await _userManager.AddToRoleAsync(item, roleName.Name);

                    return CreatedAtAction("GetById", new { item.Id }, acc);
                }
                else
                {
                    return new JsonResult("Created fails") { StatusCode = 500 };
                }

              
            }

            return new JsonResult("Something went wrong") { StatusCode = 500 };
        }

        [Authorize(Roles = "Admin")]
        [HttpPut("{id}")]
        public async Task<IActionResult> Update(string id,[FromForm] UpdateAccountDTO acc)
        {
            Account? exist = await _context.Users.FirstOrDefaultAsync(t => t.Id == id);


            if (exist == null)
            {
                throw new ArgumentException($"Account with ID: {id} not found");
            }

            var avatar = await _commonService.UploadFile(acc.Avatar);

            if (ModelState.IsValid)
            {
                exist.UserName = acc.Username;
                exist.PhoneNumber = acc.Phone;
                exist.Address = acc.Address;
                exist.Gender = (acc.Gender != null) ?(acc.Gender.Equals("1") ? true : false): false;
       
                if (avatar != null && avatar.Length > 0)
                {
                    exist.Avatar = avatar;
                }
                var currentRoles = await _userManager.GetRolesAsync(exist);
                var roleName = await _context.Roles.FindAsync(acc.Role);
                await _userManager.RemoveFromRoleAsync(exist, currentRoles.First());
                await _userManager.AddToRoleAsync(exist, roleName.Name);
                await _context.SaveChangesAsync();
                return Ok(exist);
            }

            return new JsonResult("Something went wrong") { StatusCode = 500 };
        }

        [Authorize(Roles = "Admin")]
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(string id)
        {
            Account? exist = await _context.Users.FirstOrDefaultAsync(t => t.Id == id);

            if (exist.Equals(null)) throw new ArgumentException($"Account with ID: {id} not found");
           
            List<RefreshToken> list = await _context.RefreshTokens.Where(rf => rf.UserId == id).ToListAsync();

            _context.RefreshTokens.RemoveRange(list);

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }

            if (ModelState.IsValid)
            {
                
                _context.Remove(exist);
                await _context.SaveChangesAsync();

                return Ok(exist);
            }
            return new JsonResult("Something went wrong") { StatusCode = 500 };

        }
        [AllowAnonymous]
        [HttpGet("root")]
        public IActionResult Index()
        {
            // Get the content root path (the root directory of the project)
            string rootPath = _env.ContentRootPath;

            // You can also get the web root path (wwwroot)
            string webRootPath = _env.WebRootPath;

            // Use these paths as needed
            return Ok(rootPath);
        }
        [AllowAnonymous]

        [Route("getimage/{fileName}")]
        public IActionResult GetImage(string fileName)
        {
            var filePath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot/images", fileName);

            if (!System.IO.File.Exists(filePath))
            {
                return Ok("thành công");
            }

            var image = System.IO.File.OpenRead(filePath);
            return File(image, "image/jpeg");
        }

        [AllowAnonymous]
        [HttpPut("user/{id}")]
        public async Task<IActionResult> UpdateUser(string id, UpdateUserDTO acc)
        {
            Account? exist = await _context.Users.FirstOrDefaultAsync(t => t.Id == id);


            if (exist == null)
            {
                throw new ArgumentException($"Account with ID: {id} not found");
            }

            exist.UserName = acc.Username;
            exist.PhoneNumber = acc.Phone;
            exist.Address = acc.Address;
            exist.Gender = (acc.Gender != null) ? (acc.Gender.Equals("1") ? true : false) : false;


            await _context.SaveChangesAsync();
            return Ok(exist);
        }
    }
}
