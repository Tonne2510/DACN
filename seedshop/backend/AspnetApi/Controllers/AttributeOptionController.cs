using AspnetApi.Common;
using AspnetApi.Data;
using AspnetApi.Dtos.AttributeOption.Request;
using AspnetApi.Models;
using JwtToken.Dtos;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;

namespace AspnetApi.Controllers
{
    [Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
    [Route("api/[controller]")]
    [ApiController]
    public class AttributeOptionController : ControllerBase
    {

        private readonly ApiDbContext _context;

        private readonly ICommonService<AttributeOption> _commonService;

        public AttributeOptionController(ApiDbContext dbContext, ICommonService<AttributeOption> commonService)
        {
            _context = dbContext;
            _commonService = commonService;
        }

        [Authorize(Roles = "Admin, Manager")]
        [HttpPost("search")]
        public async Task<IActionResult> Get([FromBody] QueryParams queryParams)
        {
            var query = _context.AttributeOptions.AsQueryable();

            var includeFunc = new Func<IQueryable<AttributeOption>, IQueryable<AttributeOption>>(query =>
                query.Include(p => p.Attribute)
            );

            var pagedResponse = await _commonService.GetPagedDataAsync(queryParams, new[] { "OptionName" }, includeFunc);

            return Ok(pagedResponse);
        }
        [Authorize(Roles = "Admin, Manager")]
        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            AttributeOption? item = await _context.AttributeOptions.FirstOrDefaultAsync(t => t.Id == id);

            if (item == null)
            {
                return new JsonResult("Attribute option id Not found") { StatusCode = 400 };
            }

            return Ok(item);

        }

        [Authorize(Roles = "Admin, Manager")]
        [HttpPost]
        public async Task<IActionResult> Add(CreateAttributeOptionDTO attributeOption)
        {
            var checkExist = await _context.AttributeOptions.FirstOrDefaultAsync(ct => ct.OptionName.Equals(attributeOption.OptionName));
            if (checkExist != null)
            {
                return new JsonResult("Attribute option is existed") { StatusCode = 400 };
            }

            if (!attributeOption.Equals(null))
            {
                AttributeOption item = new AttributeOption()
                {

                    OptionName = attributeOption.OptionName,
                    Attribute = await _context.Attributes.FindAsync(attributeOption.AttributeId),
                    Slug = SlugHelper.GenerateSlug(attributeOption.OptionName)
                };
                await _context.AttributeOptions.AddAsync(item);
                await _context.SaveChangesAsync();

                return CreatedAtAction("GetById", new { item.Id }, attributeOption);
            }

            return new JsonResult("Something went wrong") { StatusCode = 500 };
        }

        [Authorize(Roles = "Admin, Manager")]
        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, UpdateAttributeOptionDTO attributeOption)
        {
            AttributeOption? exist = await _context.AttributeOptions.FirstOrDefaultAsync(t => t.Id == id);


            if (exist == null)
            {
                throw new ArgumentException($"Attribute option with ID: {id} not found");
            }

            if (ModelState.IsValid)
            {
                exist.AttributeId = attributeOption.AttributeId;
                exist.OptionName = attributeOption.OptionName;
                exist.Slug = SlugHelper.GenerateSlug(attributeOption.OptionName);

                await _context.SaveChangesAsync();

                return Ok(exist);
            }

            return new JsonResult("Something went wrong") { StatusCode = 500 };
        }

        [Authorize(Roles = "Admin, Manager")]
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            AttributeOption? exist = await _context.AttributeOptions.FirstOrDefaultAsync(t => t.Id == id);


            if (exist.Equals(null)) throw new ArgumentException($"Attribute option with ID: {id} not found");

            if (ModelState.IsValid)
            {
                _context.Remove(exist);
                await _context.SaveChangesAsync();

                return Ok(exist);
            }
            return new JsonResult("Something went wrong") { StatusCode = 500 };

        }
        [Authorize(Roles = "Admin, Manager")]
        [Route("getbyattribute/{id}")]
        public async Task<IActionResult> GetOptionsByAttributeId(int id)
        {
            var items = await _context.AttributeOptions
                             .Where(t => t.AttributeId == id)
                             .ToListAsync();

            if (items == null || !items.Any())
            {
                return Ok();
            }

            return Ok(items);

        }
    }
}
