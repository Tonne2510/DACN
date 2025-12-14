using AspnetApi.Models;
using Microsoft.AspNetCore.Identity;

namespace AspnetApi.Data
{
    public class IdentitySeeder
    {
        private readonly RoleManager<IdentityRole> _roleManager;
        private readonly UserManager<Account> _userManager;

        public IdentitySeeder(RoleManager<IdentityRole> roleManager, UserManager<Account> userManager)
        {
            _roleManager = roleManager;
            _userManager = userManager;
        }

        public async Task SeedAsync()
        {
            // Create roles
            await CreateRoleAsync("Admin");
            await CreateRoleAsync("Manager");
            await CreateRoleAsync("User");

            // Create users
            await CreateUserAsync("admin@gmail.com", "Admin123!", "Admin");
            await CreateUserAsync("manager@gmail.com", "Manager123!", "Manager");
            await CreateUserAsync("user@gmail.com", "User123!", "User");
        }

        private async Task CreateRoleAsync(string roleName)
        {
                if (!await _roleManager.RoleExistsAsync(roleName))
            {
                await _roleManager.CreateAsync(new IdentityRole(roleName));
            }
        }

        private async Task CreateUserAsync(string email, string password, string roleName)
        {
            var user = await _userManager.FindByEmailAsync(email);
            if (user == null)
            {
                user = new Account { UserName = email, Email = email };
                await _userManager.CreateAsync(user, password);
                await _userManager.AddToRoleAsync(user, roleName);
            }
        }
    }
}
