import logging
import os
import base64
import sqlalchemy
from google.cloud.sql.connector import Connector, IPTypes
import pg8000

from utils.helpers import get_required_env_var

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Database configuration from environment variables
project_id = get_required_env_var("GOOGLE_CLOUD_PROJECT")
location = os.environ.get("GOOGLE_CLOUD_REGION", "us-central1")  # Default value provided
instance_name = get_required_env_var("INSTANCE_NAME")
instance_connection_name = f"{project_id}:{location}:{instance_name}"
logger.info(f"Instance connection name: {instance_connection_name}")

def connect_with_connector() -> sqlalchemy.engine.base.Engine:
    """
    Create a connection pool to a Cloud SQL PostgreSQL database using the Cloud SQL Python Connector.
    
    Returns:
        sqlalchemy.engine.base.Engine: SQLAlchemy engine with connection pool
    """
    db_user = get_required_env_var("DB_USER")
    db_pass = get_required_env_var("DB_PASS")
    db_name = get_required_env_var("DB_NAME")

    # Log that we have the required credentials (without showing the values)
    logger.info(f"Database connection configured for database: {db_name}")
    
    ip_type = IPTypes.PRIVATE if os.environ.get("PRIVATE_IP") else IPTypes.PUBLIC

    connector = Connector()

    def getconn() -> pg8000.dbapi.Connection:
        conn: pg8000.dbapi.Connection = connector.connect(
            instance_connection_name,
            "pg8000",
            user=db_user,
            password=db_pass,
            db=db_name,
            ip_type=ip_type,
        )
        return conn

    pool = sqlalchemy.create_engine(
        "postgresql+pg8000://",
        creator=getconn,
        pool_size=2,
        max_overflow=2,
        pool_timeout=30,  # 30 seconds
        pool_recycle=1800,  # 30 minutes
    )
    return pool



def init_connection_pool() -> sqlalchemy.engine.base.Engine:
    """
    Initialize the database connection pool
    
    Returns:
        sqlalchemy.engine.base.Engine: SQLAlchemy engine with connection pool
    """        
    return connect_with_connector()

def get_curriculum(year: int, subject: str):
    """
    Get school curriculum for a specified year and subject
    
    Args:
        year: Academic year (grade level)
        subject: Academic subject (e.g., "Mathematics")
        
    Returns:
        str: Curriculum description or None if not found
    """
    try:
        stmt = sqlalchemy.text(
            "SELECT description FROM curriculums WHERE year = :year AND subject = :subject"
        )

        with db.connect() as conn:
            logger.info(f"Querying curriculum for year {year}, subject '{subject}'")
            result = conn.execute(stmt, parameters={"year": year, "subject": subject})
            row = result.fetchone()
            
        if row:
            logger.info(f"Found curriculum for year {year}, subject '{subject}'")
            return row[0]  
        else:
            logger.info(f"No curriculum found for year {year}, subject '{subject}'")
            return None  

    except Exception as e:
        logger.error(f"Error retrieving curriculum: {e}")
        return None

# Initialize the database connection pool
try:
    db = init_connection_pool()
    logger.info("Database connection pool initialized successfully")
except Exception as e:
    logger.error(f"Failed to initialize database connection pool: {e}")
    raise


# if __name__ == "__main__":
#     result = get_curriculum(6, "Mathematics")
#     if result:
#         logger.info(f"Curriculum found: {result[:100]}...")  # Print the first 100 chars
#     else:
#         logger.info("No curriculum found")



