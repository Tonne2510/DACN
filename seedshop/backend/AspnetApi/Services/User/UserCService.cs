using AspnetApi.Models;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;

namespace AspnetApi.Services.User
{
    public class UserCService
    {
        private readonly UserManager<Account> _userManager;

        public UserCService(UserManager<Account> userManager)
        {
            _userManager = userManager;
        }

        public async Task<IList<string>> GetUserRoles(string userId)
        {
            var user = await _userManager.FindByIdAsync(userId);
            if (user == null)
            {
                throw new ArgumentException("User not found");
            }


            return await _userManager.GetRolesAsync(user);
        }
    }
}
