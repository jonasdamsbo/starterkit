using myshared.Models;

namespace myshared.DTOs
{
	public class PortfolioProjectDTO
	{
		public int Id { get; set; }
		public string? Title { get; set; }
		public string? Description { get; set; }

		public PortfolioProjectDTO() { }
		public PortfolioProjectDTO(PortfolioProject portfolioProject) =>
		(Id, Title, Description) = (portfolioProject.Id, portfolioProject.Title, portfolioProject.Description);
	}
}
