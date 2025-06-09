using Monolith.Logic.DTOs;
using Monolith.Query.Projections;

namespace Monolith.Query.Repositories
{
	public interface IExampleModelRepository
	{
		Task<List<ExampleProjection>?> GetAllAsync();
		Task<ExampleProjection?> GetByIdAsync(string id);
		Task<ExampleProjection?> AddAsync(ExampleDTO exampleDTO);
		Task<ExampleProjection?> UpdateAsync(string id, ExampleDTO updatedExampleDTO);
		Task<ExampleProjection?> DeleteAsync(string id);
	}
}
