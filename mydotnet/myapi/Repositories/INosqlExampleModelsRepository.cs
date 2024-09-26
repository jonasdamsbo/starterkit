using myshared.Models;
using myshared.DTOs;

namespace myapi.Repositories
{
	public interface INosqlExampleModelsRepository
	{
		Task<List<NosqlExampleModel>> GetAllAsync();
		Task<NosqlExampleModel> GetByIdAsync(int id);
		Task AddAsync(NosqlExampleModel example);
		Task UpdateAsync(int id, NosqlExampleModel example);
		Task DeleteAsync(int id);
	}
}
