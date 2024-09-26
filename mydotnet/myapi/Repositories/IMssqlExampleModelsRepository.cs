using myshared.Models;
using myshared.DTOs;

namespace myapi.Repositories
{
	public interface IMssqlExampleModelsRepository
	{
		Task<List<MssqlExampleModel>> GetAllAsync();
		Task<MssqlExampleModel> GetByIdAsync(int id);
		Task AddAsync(ExampleDTO exampleDTO);
		Task UpdateAsync(ExampleDTO exampleDTO, int id);
		Task DeleteAsync(int id);
	}
}
