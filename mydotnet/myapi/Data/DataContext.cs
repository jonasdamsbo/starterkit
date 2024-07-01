using Microsoft.EntityFrameworkCore;
using myshared.Models;

namespace myapi.Data
{
    public class DataContext : DbContext
    {
        public DataContext(DbContextOptions<DataContext> options) : base (options)
        {
        }

		public DbSet<PortfolioProject> PortfolioProjects => Set<PortfolioProject>();
		//public DbSet<PortfolioProject> PortfolioProjects { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<PortfolioProject>().HasData(
                new PortfolioProject { Id = 1, Title = "First project", Description = "Alot of fun", WebUrl = "google.dk" },
                new PortfolioProject { Id = 2, Title = "Second project", Description = "Alot of fun", WebUrl = "google.dk" },
                new PortfolioProject { Id = 3, Title = "Third project", Description = "Alot of fun", WebUrl = "google.dk" }
            );

            //modelBuilder.Entity<PortfolioProject>();
            //modelBuilder.Entity<PortfolioProject>().ToTable("PortfolioProjects");
        }
    }
}
