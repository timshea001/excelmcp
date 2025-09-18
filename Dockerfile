FROM python:3.11-slim

WORKDIR /app

# Install uv
RUN pip install uv

# Copy project files
COPY . .

# Create excel_files directory
RUN mkdir -p /app/excel_files

# Install dependencies directly from PyPI instead of building from source
RUN uv pip install --system excel-mcp-server==0.1.7

# Expose port
EXPOSE 8000

# Set environment variables
ENV EXCEL_FILES_PATH=/app/excel_files
ENV FASTMCP_PORT=8000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:8000/health || exit 1

# Start the server
CMD ["uvx", "excel-mcp-server", "streamable-http"]