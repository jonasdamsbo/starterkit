using myshared.Models;
using myshared.DTOs;

namespace myapi.Repositories
{
	public interface INosqlExampleModelRepository
	{
		Task<List<NosqlExampleModel>> GetAllAsync();
		Task<NosqlExampleModel> GetByIdAsync(int id);
		Task<NosqlExampleModel> AddAsync(NosqlExampleModel example);
		Task<NosqlExampleModel> UpdateAsync(int id, NosqlExampleModel example);
		Task<NosqlExampleModel> DeleteAsync(int id);
	}
}
