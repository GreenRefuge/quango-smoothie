
from uvicorn.workers import UvicornWorker

class MyUvicornWorker(UvicornWorker):
	
	CONFIG_KWARGS = {
		# Django (for now) does not support ASGI Lifespan, so explicitly disable to quiet warnings
		"lifespan": "off", 
		
		#"uds": "/tmp/shared_sockets/uvicorn.sock", 
		
		# !!
		"forwarded_allow_ips": "*", 
		"proxy_headers": True, 
		
		#"loop"    : "asyncio", 
		#"http"    : "h11", 
		# !!
		#"reload": True,
		#"host": "0.0.0.0", 
		#"workers": "1", 
	}
