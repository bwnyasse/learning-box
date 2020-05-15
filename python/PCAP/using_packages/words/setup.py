from setuptools import find_packages, setup

setup(
    name="words",
    version="1.0.0",
    description="Helper library for working with random words",
    package_dir={"": "src"},
    packages=find_packages(where="src"),
)