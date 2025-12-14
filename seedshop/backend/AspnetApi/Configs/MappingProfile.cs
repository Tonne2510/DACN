using AspnetApi.Models;
using AutoMapper;
using Microsoft.AspNetCore.Identity;
namespace AspnetApi.Configs
{


    public class MappingProfile : Profile
    {
        public MappingProfile()
        {
           CreateMap<IdentityUser, Account>();
           CreateMap<Account, IdentityUser>();
           
        }
    }

}
