using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace myapi.Migrations
{
    /// <inheritdoc />
    public partial class second : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "Secret",
                table: "PortfolioProjects",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.UpdateData(
                table: "PortfolioProjects",
                keyColumn: "Id",
                keyValue: 1,
                column: "Secret",
                value: null);

            migrationBuilder.UpdateData(
                table: "PortfolioProjects",
                keyColumn: "Id",
                keyValue: 2,
                column: "Secret",
                value: null);

            migrationBuilder.UpdateData(
                table: "PortfolioProjects",
                keyColumn: "Id",
                keyValue: 3,
                column: "Secret",
                value: null);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Secret",
                table: "PortfolioProjects");
        }
    }
}
