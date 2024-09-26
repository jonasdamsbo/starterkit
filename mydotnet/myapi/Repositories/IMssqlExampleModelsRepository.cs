using myshared.Models;
using myshared.DTOs;

namespace myapi.Repositories
{
	public interface IMssqlExampleModelsRepository
	{
		Task<List<MssqlExampleModel>> GetAllAsync();
		Task<MssqlExampleModel> GetByIdAsync(int id);
		Task<MssqlExampleModel> AddAsync(MssqlExampleModel example);
		Task<MssqlExampleModel> UpdateAsync(int id, MssqlExampleModel example);
		Task<MssqlExampleModel> DeleteAsync(int id);
	}
}
