# Rails 8 + Vue Template

This is a template for a Rails 8 application with Vue integration. Follow the instructions below to set up and run the application.

## Prerequisites

- Ruby 3.0.0 or higher
- Rails 8.0.0 or higher
- Node.js 14.0.0 or higher
- Yarn
- Foreman

## Getting Started

1. Clone the repository:

    ```sh
    git clone https://github.com/Wolwer1nE/rails_vue_sample
    cd rails_vue_sample
    ```

2. Install dependencies:

    ```sh
    bundle install
    yarn install
    ```

3. Set up the database:

    ```sh
    rails db:create
    rails db:migrate
    ```

4. Start the application using Foreman:

    ```sh
    foreman start -f Procfile.dev
    ```

    This will start both the Rails server and the esbuild + tailwind builds.

## Directory Structure

- `app/javascript`: Vue components and JavaScript files
- `app/views`: Rails views
- `config`: Configuration files
- `db`: Database migrations and schema

## Additional Resources

- [Rails Guides](https://guides.rubyonrails.org/)

## License

This project is licensed under the MIT License.
