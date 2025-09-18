FROM python:3.11-slim

WORKDIR /app

# Install uv
RUN pip install uv

# Copy project files
COPY . .

# Create excel_files directory
RUN mkdir -p /app/excel_files

# Install dependencies
RUN uv pip install --system .

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