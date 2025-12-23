using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace Monolith.Data.Migrations
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
                    { "673697f3ee328ebb2ba5d8cf", "Some field of first example", "First example", "google.dk" },
                    { "673697f3ee328ebb2ba5d8d1", "Some field of second example", "Second example", "google.dk" },
                    { "673697f3ee328ebb2ba5d8d3", "Some field of third example", "Third example", "google.dk" }
                });

            migrationBuilder.InsertData(
                table: "ExampleNavigationProperties",
                columns: new[] { "Id", "ExampleModelId", "Title" },
                values: new object[,]
                {
                    { "673697f3ee328ebb2ba5d8d4", "673697f3ee328ebb2ba5d8cf", "First navprop" },
                    { "673697f3ee328ebb2ba5d8d5", "673697f3ee328ebb2ba5d8cf", "Second navprop" },
                    { "673697f3ee328ebb2ba5d8d6", "673697f3ee328ebb2ba5d8d1", "Third navprop" }
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
