using myshared.Models;
using myshared.DTOs;

namespace myapi.Repositories
{
	public interface IMssqlExampleModelsRepository
	{
		Task<List<MssqlExampleModel>> GetAllAsync();
		Task<MssqlExampleModel> GetByIdAsync(int id);
		Task AddAsync(MssqlExampleModel example);
		Task UpdateAsync(int id, MssqlExampleModel example);
		Task DeleteAsync(int id);
	}
}
