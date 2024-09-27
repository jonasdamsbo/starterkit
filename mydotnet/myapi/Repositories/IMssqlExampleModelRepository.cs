using myshared.Models;
using myshared.DTOs;

namespace myapi.Repositories
{
	public interface IMssqlExampleModelRepository : IRepository
	{
		Task<List<ExampleModel>> GetAllAsync();
		Task<ExampleModel> GetByIdAsync(string id);
		Task<ExampleModel> AddAsync(ExampleModel example);
		Task<ExampleModel> UpdateAsync(string id, ExampleModel example);
		Task<ExampleModel> DeleteAsync(string id);
	}
}
