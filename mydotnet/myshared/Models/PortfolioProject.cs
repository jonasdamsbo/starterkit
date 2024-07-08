using myshared.DTOs;

namespace myshared.Models
{
    public class PortfolioProject
    {
        public int Id { get; set; }
        public string? Title { get; set; }
        public string? Description { get; set; }
        public string? WebUrl { get; set; }
		public string? Secret { get; set; }

		public PortfolioProject() { }
		public PortfolioProject(PortfolioProjectDTO portfolioProjectDTO) =>
		(Id, Title, Description) = (portfolioProjectDTO.Id, portfolioProjectDTO.Title, portfolioProjectDTO.Description);
	}
}