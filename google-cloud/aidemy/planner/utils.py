import os

def get_required_env_var(var_name):
    """
    Get a required environment variable or raise an error if it's not set
    
    Args:
        var_name: Name of the environment variable
        
    Returns:
        str: Value of the environment variable
        
    Raises:
        ValueError: If the environment variable is not set
    """
    value = os.environ.get(var_name)
    if not value:
        raise ValueError(f"Missing required environment variable: {var_name}")
    return value