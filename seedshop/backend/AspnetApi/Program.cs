using AspnetApi.Common;
using AspnetApi.Config;
using AspnetApi.Configs;
using AspnetApi.Data;
using AspnetApi.Models;
using AspnetApi.Services.Auth;
using AspnetApi.Services.User;
using AspnetApi.Utils;
using AutoMapper;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.Text;
var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllers();

// Add DbContext
builder.Services.AddDbContext<ApiDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("AppContext")));

// Configure CORS
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAllOrigins",
        builder =>
        {
            builder.AllowAnyOrigin()
                   .AllowAnyHeader()
                   .AllowAnyMethod();
        });
});

// Configure Authentication
var key = Encoding.ASCII.GetBytes(builder.Configuration["JwtConfig:Secret"]);
builder.Services.Configure<JwtConfig>(builder.Configuration.GetSection("JwtConfig"));

builder.Services.AddAuthentication(options =>
{
    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
})
.AddJwtBearer(jwt =>
{
    jwt.SaveToken = true;
    jwt.TokenValidationParameters = new TokenValidationParameters
    {
        ValidateIssuerSigningKey = true,
        IssuerSigningKey = new SymmetricSecurityKey(key),
        ValidateIssuer = false,
        ValidateAudience = false,
        ValidateLifetime = true,
        RequireExpirationTime = false
    };
});

// Configure Identity
builder.Services.AddIdentity<Account, IdentityRole>(options =>
{
    options.SignIn.RequireConfirmedAccount = true;
})
.AddEntityFrameworkStores<ApiDbContext>()
.AddDefaultTokenProviders();

// Register Dependency Injection (DI)
builder.Services.AddScoped<IJwtService, JwtService>();
builder.Services.AddScoped<UserCService>();
builder.Services.AddScoped<IdentitySeeder>();
builder.Services.AddScoped(typeof(ICommonService<>), typeof(CommonService<>));

// Register TokenValidationParameters
builder.Services.AddSingleton(new TokenValidationParameters
{
    ValidateIssuerSigningKey = true,
    IssuerSigningKey = new SymmetricSecurityKey(Encoding.ASCII.GetBytes(builder.Configuration["JwtConfig:Secret"])),
    ValidateIssuer = false,
    ValidateAudience = false,
    ValidateLifetime = true,
    RequireExpirationTime = false
});


// Configure AutoMapper
builder.Services.AddAutoMapper(typeof(MappingProfile));

// Build the app
var app = builder.Build();

// Configure middleware
app.UseHttpsRedirection();
app.UseCors("AllowAllOrigins"); // Apply CORS policy
app.UseAuthentication();
app.UseAuthorization();

// Seed Identity data
using (var scope = app.Services.CreateScope())
{
    var identitySeeder = scope.ServiceProvider.GetRequiredService<IdentitySeeder>();
    await identitySeeder.SeedAsync();
}
app.UseCors("AllowAllOrigins");
// Map controllers
app.UseStaticFiles();

app.MapControllers();

app.Run();
