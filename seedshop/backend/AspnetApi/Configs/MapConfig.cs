
using AspnetApi.Models;
using AutoMapper;
using Microsoft.AspNetCore.Identity;

namespace AspnetApi.Configs
{
    public class MapConfig
    {
        public static Mapper InitializeAutomapper()
        {
            //Provide all the Mapping Configuration
            var config = new MapperConfiguration(cfg =>
            {
              cfg.CreateMap<IdentityUser, Account>();
              cfg.CreateMap<Account, IdentityUser>();
            });
         

            var mapper = new Mapper(config);
            return mapper;
        }
    }
}
