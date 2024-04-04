using myblazor.Models;

namespace myblazor.Services
{
	public interface IPortfolioService
	{
		Task<List<PortfolioProject>> GetAllProjectsAsync();
		Task<PortfolioProject> GetProjectByIdAsync(int id);
		Task AddProjectAsync(PortfolioProject project);
		Task UpdateProjectAsync(PortfolioProject project, int id);
		Task DeleteProjectAsync(int id);
	}
}
