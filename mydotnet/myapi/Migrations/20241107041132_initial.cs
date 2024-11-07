using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace myapi.Migrations
{
    /// <inheritdoc />
    public partial class initial : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "ExampleModels",
                columns: table => new
                {
                    Id = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    Title = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Description = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    WebUrl = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ExampleModels", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "ExampleNavigationProperties",
                columns: table => new
                {
                    Id = table.Column<string>(type: "nvarchar(450)", nullable: false),
                    Title = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    ExampleModelId = table.Column<string>(type: "nvarchar(450)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ExampleNavigationProperties", x => x.Id);
                    table.ForeignKey(
                        name: "FK_ExampleNavigationProperties_ExampleModels_ExampleModelId",
                        column: x => x.ExampleModelId,
                        principalTable: "ExampleModels",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.InsertData(
                table: "ExampleModels",
                columns: new[] { "Id", "Description", "Title", "WebUrl" },
                values: new object[,]
                {
                    { "672c3df356274e2164c88fa4", "Alot of fun", "First project", "google.dk" },
                    { "672c3df356274e2164c88fa5", "Alot of fun", "Second project", "google.dk" },
                    { "672c3df356274e2164c88fa6", "Alot of fun", "Third project", "google.dk" }
                });

            migrationBuilder.InsertData(
                table: "ExampleNavigationProperties",
                columns: new[] { "Id", "ExampleModelId", "Title" },
                values: new object[,]
                {
                    { "672c3df356274e2164c88fa7", "672c3df356274e2164c88fa4", "First navprop" },
                    { "672c3df356274e2164c88fa8", "672c3df356274e2164c88fa4", "Second navprop" },
                    { "672c3df356274e2164c88fa9", "672c3df356274e2164c88fa5", "Third navprop" }
                });

            migrationBuilder.CreateIndex(
                name: "IX_ExampleNavigationProperties_ExampleModelId",
                table: "ExampleNavigationProperties",
                column: "ExampleModelId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "ExampleNavigationProperties");

            migrationBuilder.DropTable(
                name: "ExampleModels");
        }
    }
}
