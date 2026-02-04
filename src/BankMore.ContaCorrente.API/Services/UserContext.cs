using System.Security.Claims;
namespace BankMore.ContaCorrente.API.Services;

public interface IUserContext { string GetUserId(); }

public class UserContext : IUserContext
{
    private readonly IHttpContextAccessor _accessor;
    public UserContext(IHttpContextAccessor accessor) => _accessor = accessor;
    public string GetUserId() => _accessor.HttpContext?.User?.FindFirst("IdConta")?.Value ?? string.Empty;
}
