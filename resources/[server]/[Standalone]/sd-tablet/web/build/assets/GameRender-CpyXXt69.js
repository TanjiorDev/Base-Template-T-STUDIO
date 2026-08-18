import{hi as e,mi as t}from"./index-BVnmmdh0.js";function n(){}Object.assign(n.prototype,{addEventListener:function(e,t){this._listeners===void 0&&(this._listeners={});var n=this._listeners;n[e]===void 0&&(n[e]=[]),n[e].indexOf(t)===-1&&n[e].push(t)},hasEventListener:function(e,t){if(this._listeners===void 0)return!1;var n=this._listeners;return n[e]!==void 0&&n[e].indexOf(t)!==-1},removeEventListener:function(e,t){if(this._listeners!==void 0){var n=this._listeners[e];if(n!==void 0){var r=n.indexOf(t);r!==-1&&n.splice(r,1)}}},dispatchEvent:function(e){if(this._listeners!==void 0){var t=this._listeners[e.type];if(t!==void 0){e.target=this;for(var n=t.slice(0),r=0,i=n.length;r<i;r++)n[r].call(this,e)}}}});var r=1e3,i=1001,a=1002,o=1003,s=1006,c=1008,l=1009,u=1012,d=1015,f=1020,p=1022,m=1023,h=3e3,g=3001,_=3007,v=3002,y=3004,b=3005,x=3006,S=3200,C=3201,w={DEG2RAD:Math.PI/180,RAD2DEG:180/Math.PI,generateUUID:(function(){for(var e=[],t=0;t<256;t++)e[t]=(t<16?`0`:``)+t.toString(16);return function(){var t=Math.random()*4294967295|0,n=Math.random()*4294967295|0,r=Math.random()*4294967295|0,i=Math.random()*4294967295|0;return(e[t&255]+e[t>>8&255]+e[t>>16&255]+e[t>>24&255]+`-`+e[n&255]+e[n>>8&255]+`-`+e[n>>16&15|64]+e[n>>24&255]+`-`+e[r&63|128]+e[r>>8&255]+`-`+e[r>>16&255]+e[r>>24&255]+e[i&255]+e[i>>8&255]+e[i>>16&255]+e[i>>24&255]).toUpperCase()}})(),clamp:function(e,t,n){return Math.max(t,Math.min(n,e))},euclideanModulo:function(e,t){return(e%t+t)%t},mapLinear:function(e,t,n,r,i){return r+(e-t)*(i-r)/(n-t)},lerp:function(e,t,n){return(1-n)*e+n*t},smoothstep:function(e,t,n){return e<=t?0:e>=n?1:(e=(e-t)/(n-t),e*e*(3-2*e))},smootherstep:function(e,t,n){return e<=t?0:e>=n?1:(e=(e-t)/(n-t),e*e*e*(e*(e*6-15)+10))},randInt:function(e,t){return e+Math.floor(Math.random()*(t-e+1))},randFloat:function(e,t){return e+Math.random()*(t-e)},randFloatSpread:function(e){return e*(.5-Math.random())},degToRad:function(e){return e*w.DEG2RAD},radToDeg:function(e){return e*w.RAD2DEG},isPowerOfTwo:function(e){return(e&e-1)==0&&e!==0},ceilPowerOfTwo:function(e){return 2**Math.ceil(Math.log(e)/Math.LN2)},floorPowerOfTwo:function(e){return 2**Math.floor(Math.log(e)/Math.LN2)}};function T(e,t){this.x=e||0,this.y=t||0}Object.defineProperties(T.prototype,{width:{get:function(){return this.x},set:function(e){this.x=e}},height:{get:function(){return this.y},set:function(e){this.y=e}}}),Object.assign(T.prototype,{isVector2:!0,set:function(e,t){return this.x=e,this.y=t,this},setScalar:function(e){return this.x=e,this.y=e,this},setX:function(e){return this.x=e,this},setY:function(e){return this.y=e,this},setComponent:function(e,t){switch(e){case 0:this.x=t;break;case 1:this.y=t;break;default:throw Error(`index is out of range: `+e)}return this},getComponent:function(e){switch(e){case 0:return this.x;case 1:return this.y;default:throw Error(`index is out of range: `+e)}},clone:function(){return new this.constructor(this.x,this.y)},copy:function(e){return this.x=e.x,this.y=e.y,this},add:function(e,t){return t===void 0?(this.x+=e.x,this.y+=e.y,this):(console.warn(`THREE.Vector2: .add() now only accepts one argument. Use .addVectors( a, b ) instead.`),this.addVectors(e,t))},addScalar:function(e){return this.x+=e,this.y+=e,this},addVectors:function(e,t){return this.x=e.x+t.x,this.y=e.y+t.y,this},addScaledVector:function(e,t){return this.x+=e.x*t,this.y+=e.y*t,this},sub:function(e,t){return t===void 0?(this.x-=e.x,this.y-=e.y,this):(console.warn(`THREE.Vector2: .sub() now only accepts one argument. Use .subVectors( a, b ) instead.`),this.subVectors(e,t))},subScalar:function(e){return this.x-=e,this.y-=e,this},subVectors:function(e,t){return this.x=e.x-t.x,this.y=e.y-t.y,this},multiply:function(e){return this.x*=e.x,this.y*=e.y,this},multiplyScalar:function(e){return this.x*=e,this.y*=e,this},divide:function(e){return this.x/=e.x,this.y/=e.y,this},divideScalar:function(e){return this.multiplyScalar(1/e)},applyMatrix3:function(e){var t=this.x,n=this.y,r=e.elements;return this.x=r[0]*t+r[3]*n+r[6],this.y=r[1]*t+r[4]*n+r[7],this},min:function(e){return this.x=Math.min(this.x,e.x),this.y=Math.min(this.y,e.y),this},max:function(e){return this.x=Math.max(this.x,e.x),this.y=Math.max(this.y,e.y),this},clamp:function(e,t){return this.x=Math.max(e.x,Math.min(t.x,this.x)),this.y=Math.max(e.y,Math.min(t.y,this.y)),this},clampScalar:function(){var e=new T,t=new T;return function(n,r){return e.set(n,n),t.set(r,r),this.clamp(e,t)}}(),clampLength:function(e,t){var n=this.length();return this.divideScalar(n||1).multiplyScalar(Math.max(e,Math.min(t,n)))},floor:function(){return this.x=Math.floor(this.x),this.y=Math.floor(this.y),this},ceil:function(){return this.x=Math.ceil(this.x),this.y=Math.ceil(this.y),this},round:function(){return this.x=Math.round(this.x),this.y=Math.round(this.y),this},roundToZero:function(){return this.x=this.x<0?Math.ceil(this.x):Math.floor(this.x),this.y=this.y<0?Math.ceil(this.y):Math.floor(this.y),this},negate:function(){return this.x=-this.x,this.y=-this.y,this},dot:function(e){return this.x*e.x+this.y*e.y},cross:function(e){return this.x*e.y-this.y*e.x},lengthSq:function(){return this.x*this.x+this.y*this.y},length:function(){return Math.sqrt(this.x*this.x+this.y*this.y)},manhattanLength:function(){return Math.abs(this.x)+Math.abs(this.y)},normalize:function(){return this.divideScalar(this.length()||1)},angle:function(){var e=Math.atan2(this.y,this.x);return e<0&&(e+=2*Math.PI),e},distanceTo:function(e){return Math.sqrt(this.distanceToSquared(e))},distanceToSquared:function(e){var t=this.x-e.x,n=this.y-e.y;return t*t+n*n},manhattanDistanceTo:function(e){return Math.abs(this.x-e.x)+Math.abs(this.y-e.y)},setLength:function(e){return this.normalize().multiplyScalar(e)},lerp:function(e,t){return this.x+=(e.x-this.x)*t,this.y+=(e.y-this.y)*t,this},lerpVectors:function(e,t,n){return this.subVectors(t,e).multiplyScalar(n).add(e)},equals:function(e){return e.x===this.x&&e.y===this.y},fromArray:function(e,t){return t===void 0&&(t=0),this.x=e[t],this.y=e[t+1],this},toArray:function(e,t){return e===void 0&&(e=[]),t===void 0&&(t=0),e[t]=this.x,e[t+1]=this.y,e},fromBufferAttribute:function(e,t,n){return n!==void 0&&console.warn(`THREE.Vector2: offset has been removed from .fromBufferAttribute().`),this.x=e.getX(t),this.y=e.getY(t),this},rotateAround:function(e,t){var n=Math.cos(t),r=Math.sin(t),i=this.x-e.x,a=this.y-e.y;return this.x=i*n-a*r+e.x,this.y=i*r+a*n+e.y,this}});function E(){this.elements=[1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1],arguments.length>0&&console.error(`THREE.Matrix4: the constructor no longer reads arguments. use .set() instead.`)}Object.assign(E.prototype,{isMatrix4:!0,set:function(e,t,n,r,i,a,o,s,c,l,u,d,f,p,m,h){var g=this.elements;return g[0]=e,g[4]=t,g[8]=n,g[12]=r,g[1]=i,g[5]=a,g[9]=o,g[13]=s,g[2]=c,g[6]=l,g[10]=u,g[14]=d,g[3]=f,g[7]=p,g[11]=m,g[15]=h,this},identity:function(){return this.set(1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1),this},clone:function(){return new E().fromArray(this.elements)},copy:function(e){var t=this.elements,n=e.elements;return t[0]=n[0],t[1]=n[1],t[2]=n[2],t[3]=n[3],t[4]=n[4],t[5]=n[5],t[6]=n[6],t[7]=n[7],t[8]=n[8],t[9]=n[9],t[10]=n[10],t[11]=n[11],t[12]=n[12],t[13]=n[13],t[14]=n[14],t[15]=n[15],this},copyPosition:function(e){var t=this.elements,n=e.elements;return t[12]=n[12],t[13]=n[13],t[14]=n[14],this},extractBasis:function(e,t,n){return e.setFromMatrixColumn(this,0),t.setFromMatrixColumn(this,1),n.setFromMatrixColumn(this,2),this},makeBasis:function(e,t,n){return this.set(e.x,t.x,n.x,0,e.y,t.y,n.y,0,e.z,t.z,n.z,0,0,0,0,1),this},extractRotation:function(){var e=new O;return function(t){var n=this.elements,r=t.elements,i=1/e.setFromMatrixColumn(t,0).length(),a=1/e.setFromMatrixColumn(t,1).length(),o=1/e.setFromMatrixColumn(t,2).length();return n[0]=r[0]*i,n[1]=r[1]*i,n[2]=r[2]*i,n[3]=0,n[4]=r[4]*a,n[5]=r[5]*a,n[6]=r[6]*a,n[7]=0,n[8]=r[8]*o,n[9]=r[9]*o,n[10]=r[10]*o,n[11]=0,n[12]=0,n[13]=0,n[14]=0,n[15]=1,this}}(),makeRotationFromEuler:function(e){e&&e.isEuler||console.error(`THREE.Matrix4: .makeRotationFromEuler() now expects a Euler rotation rather than a Vector3 and order.`);var t=this.elements,n=e.x,r=e.y,i=e.z,a=Math.cos(n),o=Math.sin(n),s=Math.cos(r),c=Math.sin(r),l=Math.cos(i),u=Math.sin(i);if(e.order===`XYZ`){var d=a*l,f=a*u,p=o*l,m=o*u;t[0]=s*l,t[4]=-s*u,t[8]=c,t[1]=f+p*c,t[5]=d-m*c,t[9]=-o*s,t[2]=m-d*c,t[6]=p+f*c,t[10]=a*s}else if(e.order===`YXZ`){var h=s*l,g=s*u,_=c*l,v=c*u;t[0]=h+v*o,t[4]=_*o-g,t[8]=a*c,t[1]=a*u,t[5]=a*l,t[9]=-o,t[2]=g*o-_,t[6]=v+h*o,t[10]=a*s}else if(e.order===`ZXY`){var h=s*l,g=s*u,_=c*l,v=c*u;t[0]=h-v*o,t[4]=-a*u,t[8]=_+g*o,t[1]=g+_*o,t[5]=a*l,t[9]=v-h*o,t[2]=-a*c,t[6]=o,t[10]=a*s}else if(e.order===`ZYX`){var d=a*l,f=a*u,p=o*l,m=o*u;t[0]=s*l,t[4]=p*c-f,t[8]=d*c+m,t[1]=s*u,t[5]=m*c+d,t[9]=f*c-p,t[2]=-c,t[6]=o*s,t[10]=a*s}else if(e.order===`YZX`){var y=a*s,b=a*c,x=o*s,S=o*c;t[0]=s*l,t[4]=S-y*u,t[8]=x*u+b,t[1]=u,t[5]=a*l,t[9]=-o*l,t[2]=-c*l,t[6]=b*u+x,t[10]=y-S*u}else if(e.order===`XZY`){var y=a*s,b=a*c,x=o*s,S=o*c;t[0]=s*l,t[4]=-u,t[8]=c*l,t[1]=y*u+S,t[5]=a*l,t[9]=b*u-x,t[2]=x*u-b,t[6]=o*l,t[10]=S*u+y}return t[3]=0,t[7]=0,t[11]=0,t[12]=0,t[13]=0,t[14]=0,t[15]=1,this},makeRotationFromQuaternion:function(){var e=new O(0,0,0),t=new O(1,1,1);return function(n){return this.compose(e,n,t)}}(),lookAt:function(){var e=new O,t=new O,n=new O;return function(r,i,a){var o=this.elements;return n.subVectors(r,i),n.lengthSq()===0&&(n.z=1),n.normalize(),e.crossVectors(a,n),e.lengthSq()===0&&(Math.abs(a.z)===1?n.x+=1e-4:n.z+=1e-4,n.normalize(),e.crossVectors(a,n)),e.normalize(),t.crossVectors(n,e),o[0]=e.x,o[4]=t.x,o[8]=n.x,o[1]=e.y,o[5]=t.y,o[9]=n.y,o[2]=e.z,o[6]=t.z,o[10]=n.z,this}}(),multiply:function(e,t){return t===void 0?this.multiplyMatrices(this,e):(console.warn(`THREE.Matrix4: .multiply() now only accepts one argument. Use .multiplyMatrices( a, b ) instead.`),this.multiplyMatrices(e,t))},premultiply:function(e){return this.multiplyMatrices(e,this)},multiplyMatrices:function(e,t){var n=e.elements,r=t.elements,i=this.elements,a=n[0],o=n[4],s=n[8],c=n[12],l=n[1],u=n[5],d=n[9],f=n[13],p=n[2],m=n[6],h=n[10],g=n[14],_=n[3],v=n[7],y=n[11],b=n[15],x=r[0],S=r[4],C=r[8],w=r[12],T=r[1],E=r[5],D=r[9],O=r[13],k=r[2],A=r[6],j=r[10],M=r[14],N=r[3],P=r[7],F=r[11],I=r[15];return i[0]=a*x+o*T+s*k+c*N,i[4]=a*S+o*E+s*A+c*P,i[8]=a*C+o*D+s*j+c*F,i[12]=a*w+o*O+s*M+c*I,i[1]=l*x+u*T+d*k+f*N,i[5]=l*S+u*E+d*A+f*P,i[9]=l*C+u*D+d*j+f*F,i[13]=l*w+u*O+d*M+f*I,i[2]=p*x+m*T+h*k+g*N,i[6]=p*S+m*E+h*A+g*P,i[10]=p*C+m*D+h*j+g*F,i[14]=p*w+m*O+h*M+g*I,i[3]=_*x+v*T+y*k+b*N,i[7]=_*S+v*E+y*A+b*P,i[11]=_*C+v*D+y*j+b*F,i[15]=_*w+v*O+y*M+b*I,this},multiplyScalar:function(e){var t=this.elements;return t[0]*=e,t[4]*=e,t[8]*=e,t[12]*=e,t[1]*=e,t[5]*=e,t[9]*=e,t[13]*=e,t[2]*=e,t[6]*=e,t[10]*=e,t[14]*=e,t[3]*=e,t[7]*=e,t[11]*=e,t[15]*=e,this},applyToBufferAttribute:function(){var e=new O;return function(t){for(var n=0,r=t.count;n<r;n++)e.x=t.getX(n),e.y=t.getY(n),e.z=t.getZ(n),e.applyMatrix4(this),t.setXYZ(n,e.x,e.y,e.z);return t}}(),determinant:function(){var e=this.elements,t=e[0],n=e[4],r=e[8],i=e[12],a=e[1],o=e[5],s=e[9],c=e[13],l=e[2],u=e[6],d=e[10],f=e[14],p=e[3],m=e[7],h=e[11],g=e[15];return p*(+i*s*u-r*c*u-i*o*d+n*c*d+r*o*f-n*s*f)+m*(+t*s*f-t*c*d+i*a*d-r*a*f+r*c*l-i*s*l)+h*(+t*c*u-t*o*f-i*a*u+n*a*f+i*o*l-n*c*l)+g*(-r*o*l-t*s*u+t*o*d+r*a*u-n*a*d+n*s*l)},transpose:function(){var e=this.elements,t=e[1];return e[1]=e[4],e[4]=t,t=e[2],e[2]=e[8],e[8]=t,t=e[6],e[6]=e[9],e[9]=t,t=e[3],e[3]=e[12],e[12]=t,t=e[7],e[7]=e[13],e[13]=t,t=e[11],e[11]=e[14],e[14]=t,this},setPosition:function(e){var t=this.elements;return t[12]=e.x,t[13]=e.y,t[14]=e.z,this},getInverse:function(e,t){var n=this.elements,r=e.elements,i=r[0],a=r[1],o=r[2],s=r[3],c=r[4],l=r[5],u=r[6],d=r[7],f=r[8],p=r[9],m=r[10],h=r[11],g=r[12],_=r[13],v=r[14],y=r[15],b=p*v*d-_*m*d+_*u*h-l*v*h-p*u*y+l*m*y,x=g*m*d-f*v*d-g*u*h+c*v*h+f*u*y-c*m*y,S=f*_*d-g*p*d+g*l*h-c*_*h-f*l*y+c*p*y,C=g*p*u-f*_*u-g*l*m+c*_*m+f*l*v-c*p*v,w=i*b+a*x+o*S+s*C;if(w===0){var T=`THREE.Matrix4: .getInverse() can't invert matrix, determinant is 0`;if(t===!0)throw Error(T);return console.warn(T),this.identity()}var E=1/w;return n[0]=b*E,n[1]=(_*m*s-p*v*s-_*o*h+a*v*h+p*o*y-a*m*y)*E,n[2]=(l*v*s-_*u*s+_*o*d-a*v*d-l*o*y+a*u*y)*E,n[3]=(p*u*s-l*m*s-p*o*d+a*m*d+l*o*h-a*u*h)*E,n[4]=x*E,n[5]=(f*v*s-g*m*s+g*o*h-i*v*h-f*o*y+i*m*y)*E,n[6]=(g*u*s-c*v*s-g*o*d+i*v*d+c*o*y-i*u*y)*E,n[7]=(c*m*s-f*u*s+f*o*d-i*m*d-c*o*h+i*u*h)*E,n[8]=S*E,n[9]=(g*p*s-f*_*s-g*a*h+i*_*h+f*a*y-i*p*y)*E,n[10]=(c*_*s-g*l*s+g*a*d-i*_*d-c*a*y+i*l*y)*E,n[11]=(f*l*s-c*p*s-f*a*d+i*p*d+c*a*h-i*l*h)*E,n[12]=C*E,n[13]=(f*_*o-g*p*o+g*a*m-i*_*m-f*a*v+i*p*v)*E,n[14]=(g*l*o-c*_*o-g*a*u+i*_*u+c*a*v-i*l*v)*E,n[15]=(c*p*o-f*l*o+f*a*u-i*p*u-c*a*m+i*l*m)*E,this},scale:function(e){var t=this.elements,n=e.x,r=e.y,i=e.z;return t[0]*=n,t[4]*=r,t[8]*=i,t[1]*=n,t[5]*=r,t[9]*=i,t[2]*=n,t[6]*=r,t[10]*=i,t[3]*=n,t[7]*=r,t[11]*=i,this},getMaxScaleOnAxis:function(){var e=this.elements,t=e[0]*e[0]+e[1]*e[1]+e[2]*e[2],n=e[4]*e[4]+e[5]*e[5]+e[6]*e[6],r=e[8]*e[8]+e[9]*e[9]+e[10]*e[10];return Math.sqrt(Math.max(t,n,r))},makeTranslation:function(e,t,n){return this.set(1,0,0,e,0,1,0,t,0,0,1,n,0,0,0,1),this},makeRotationX:function(e){var t=Math.cos(e),n=Math.sin(e);return this.set(1,0,0,0,0,t,-n,0,0,n,t,0,0,0,0,1),this},makeRotationY:function(e){var t=Math.cos(e),n=Math.sin(e);return this.set(t,0,n,0,0,1,0,0,-n,0,t,0,0,0,0,1),this},makeRotationZ:function(e){var t=Math.cos(e),n=Math.sin(e);return this.set(t,-n,0,0,n,t,0,0,0,0,1,0,0,0,0,1),this},makeRotationAxis:function(e,t){var n=Math.cos(t),r=Math.sin(t),i=1-n,a=e.x,o=e.y,s=e.z,c=i*a,l=i*o;return this.set(c*a+n,c*o-r*s,c*s+r*o,0,c*o+r*s,l*o+n,l*s-r*a,0,c*s-r*o,l*s+r*a,i*s*s+n,0,0,0,0,1),this},makeScale:function(e,t,n){return this.set(e,0,0,0,0,t,0,0,0,0,n,0,0,0,0,1),this},makeShear:function(e,t,n){return this.set(1,t,n,0,e,1,n,0,e,t,1,0,0,0,0,1),this},compose:function(e,t,n){var r=this.elements,i=t._x,a=t._y,o=t._z,s=t._w,c=i+i,l=a+a,u=o+o,d=i*c,f=i*l,p=i*u,m=a*l,h=a*u,g=o*u,_=s*c,v=s*l,y=s*u,b=n.x,x=n.y,S=n.z;return r[0]=(1-(m+g))*b,r[1]=(f+y)*b,r[2]=(p-v)*b,r[3]=0,r[4]=(f-y)*x,r[5]=(1-(d+g))*x,r[6]=(h+_)*x,r[7]=0,r[8]=(p+v)*S,r[9]=(h-_)*S,r[10]=(1-(d+m))*S,r[11]=0,r[12]=e.x,r[13]=e.y,r[14]=e.z,r[15]=1,this},decompose:function(){var e=new O,t=new E;return function(n,r,i){var a=this.elements,o=e.set(a[0],a[1],a[2]).length(),s=e.set(a[4],a[5],a[6]).length(),c=e.set(a[8],a[9],a[10]).length();this.determinant()<0&&(o=-o),n.x=a[12],n.y=a[13],n.z=a[14],t.copy(this);var l=1/o,u=1/s,d=1/c;return t.elements[0]*=l,t.elements[1]*=l,t.elements[2]*=l,t.elements[4]*=u,t.elements[5]*=u,t.elements[6]*=u,t.elements[8]*=d,t.elements[9]*=d,t.elements[10]*=d,r.setFromRotationMatrix(t),i.x=o,i.y=s,i.z=c,this}}(),makePerspective:function(e,t,n,r,i,a){a===void 0&&console.warn(`THREE.Matrix4: .makePerspective() has been redefined and has a new signature. Please check the docs.`);var o=this.elements,s=2*i/(t-e),c=2*i/(n-r),l=(t+e)/(t-e),u=(n+r)/(n-r),d=-(a+i)/(a-i),f=-2*a*i/(a-i);return o[0]=s,o[4]=0,o[8]=l,o[12]=0,o[1]=0,o[5]=c,o[9]=u,o[13]=0,o[2]=0,o[6]=0,o[10]=d,o[14]=f,o[3]=0,o[7]=0,o[11]=-1,o[15]=0,this},makeOrthographic:function(e,t,n,r,i,a){var o=this.elements,s=1/(t-e),c=1/(n-r),l=1/(a-i),u=(t+e)*s,d=(n+r)*c,f=(a+i)*l;return o[0]=2*s,o[4]=0,o[8]=0,o[12]=-u,o[1]=0,o[5]=2*c,o[9]=0,o[13]=-d,o[2]=0,o[6]=0,o[10]=-2*l,o[14]=-f,o[3]=0,o[7]=0,o[11]=0,o[15]=1,this},equals:function(e){for(var t=this.elements,n=e.elements,r=0;r<16;r++)if(t[r]!==n[r])return!1;return!0},fromArray:function(e,t){t===void 0&&(t=0);for(var n=0;n<16;n++)this.elements[n]=e[n+t];return this},toArray:function(e,t){e===void 0&&(e=[]),t===void 0&&(t=0);var n=this.elements;return e[t]=n[0],e[t+1]=n[1],e[t+2]=n[2],e[t+3]=n[3],e[t+4]=n[4],e[t+5]=n[5],e[t+6]=n[6],e[t+7]=n[7],e[t+8]=n[8],e[t+9]=n[9],e[t+10]=n[10],e[t+11]=n[11],e[t+12]=n[12],e[t+13]=n[13],e[t+14]=n[14],e[t+15]=n[15],e}});function D(e,t,n,r){this._x=e||0,this._y=t||0,this._z=n||0,this._w=r===void 0?1:r}Object.assign(D,{slerp:function(e,t,n,r){return n.copy(e).slerp(t,r)},slerpFlat:function(e,t,n,r,i,a,o){var s=n[r+0],c=n[r+1],l=n[r+2],u=n[r+3],d=i[a+0],f=i[a+1],p=i[a+2],m=i[a+3];if(u!==m||s!==d||c!==f||l!==p){var h=1-o,g=s*d+c*f+l*p+u*m,_=g>=0?1:-1,v=1-g*g;if(v>2**-52){var y=Math.sqrt(v),b=Math.atan2(y,g*_);h=Math.sin(h*b)/y,o=Math.sin(o*b)/y}var x=o*_;if(s=s*h+d*x,c=c*h+f*x,l=l*h+p*x,u=u*h+m*x,h===1-o){var S=1/Math.sqrt(s*s+c*c+l*l+u*u);s*=S,c*=S,l*=S,u*=S}}e[t]=s,e[t+1]=c,e[t+2]=l,e[t+3]=u}}),Object.defineProperties(D.prototype,{x:{get:function(){return this._x},set:function(e){this._x=e,this.onChangeCallback()}},y:{get:function(){return this._y},set:function(e){this._y=e,this.onChangeCallback()}},z:{get:function(){return this._z},set:function(e){this._z=e,this.onChangeCallback()}},w:{get:function(){return this._w},set:function(e){this._w=e,this.onChangeCallback()}}}),Object.assign(D.prototype,{isQuaternion:!0,set:function(e,t,n,r){return this._x=e,this._y=t,this._z=n,this._w=r,this.onChangeCallback(),this},clone:function(){return new this.constructor(this._x,this._y,this._z,this._w)},copy:function(e){return this._x=e.x,this._y=e.y,this._z=e.z,this._w=e.w,this.onChangeCallback(),this},setFromEuler:function(e,t){if(!(e&&e.isEuler))throw Error(`THREE.Quaternion: .setFromEuler() now expects an Euler rotation rather than a Vector3 and order.`);var n=e._x,r=e._y,i=e._z,a=e.order,o=Math.cos,s=Math.sin,c=o(n/2),l=o(r/2),u=o(i/2),d=s(n/2),f=s(r/2),p=s(i/2);return a===`XYZ`?(this._x=d*l*u+c*f*p,this._y=c*f*u-d*l*p,this._z=c*l*p+d*f*u,this._w=c*l*u-d*f*p):a===`YXZ`?(this._x=d*l*u+c*f*p,this._y=c*f*u-d*l*p,this._z=c*l*p-d*f*u,this._w=c*l*u+d*f*p):a===`ZXY`?(this._x=d*l*u-c*f*p,this._y=c*f*u+d*l*p,this._z=c*l*p+d*f*u,this._w=c*l*u-d*f*p):a===`ZYX`?(this._x=d*l*u-c*f*p,this._y=c*f*u+d*l*p,this._z=c*l*p-d*f*u,this._w=c*l*u+d*f*p):a===`YZX`?(this._x=d*l*u+c*f*p,this._y=c*f*u+d*l*p,this._z=c*l*p-d*f*u,this._w=c*l*u-d*f*p):a===`XZY`&&(this._x=d*l*u-c*f*p,this._y=c*f*u-d*l*p,this._z=c*l*p+d*f*u,this._w=c*l*u+d*f*p),t!==!1&&this.onChangeCallback(),this},setFromAxisAngle:function(e,t){var n=t/2,r=Math.sin(n);return this._x=e.x*r,this._y=e.y*r,this._z=e.z*r,this._w=Math.cos(n),this.onChangeCallback(),this},setFromRotationMatrix:function(e){var t=e.elements,n=t[0],r=t[4],i=t[8],a=t[1],o=t[5],s=t[9],c=t[2],l=t[6],u=t[10],d=n+o+u,f;return d>0?(f=.5/Math.sqrt(d+1),this._w=.25/f,this._x=(l-s)*f,this._y=(i-c)*f,this._z=(a-r)*f):n>o&&n>u?(f=2*Math.sqrt(1+n-o-u),this._w=(l-s)/f,this._x=.25*f,this._y=(r+a)/f,this._z=(i+c)/f):o>u?(f=2*Math.sqrt(1+o-n-u),this._w=(i-c)/f,this._x=(r+a)/f,this._y=.25*f,this._z=(s+l)/f):(f=2*Math.sqrt(1+u-n-o),this._w=(a-r)/f,this._x=(i+c)/f,this._y=(s+l)/f,this._z=.25*f),this.onChangeCallback(),this},setFromUnitVectors:function(){var e=new O,t,n=1e-6;return function(r,i){return e===void 0&&(e=new O),t=r.dot(i)+1,t<n?(t=0,Math.abs(r.x)>Math.abs(r.z)?e.set(-r.y,r.x,0):e.set(0,-r.z,r.y)):e.crossVectors(r,i),this._x=e.x,this._y=e.y,this._z=e.z,this._w=t,this.normalize()}}(),angleTo:function(e){return 2*Math.acos(Math.abs(w.clamp(this.dot(e),-1,1)))},rotateTowards:function(e,t){var n=this.angleTo(e);if(n===0)return this;var r=Math.min(1,t/n);return this.slerp(e,r),this},inverse:function(){return this.conjugate()},conjugate:function(){return this._x*=-1,this._y*=-1,this._z*=-1,this.onChangeCallback(),this},dot:function(e){return this._x*e._x+this._y*e._y+this._z*e._z+this._w*e._w},lengthSq:function(){return this._x*this._x+this._y*this._y+this._z*this._z+this._w*this._w},length:function(){return Math.sqrt(this._x*this._x+this._y*this._y+this._z*this._z+this._w*this._w)},normalize:function(){var e=this.length();return e===0?(this._x=0,this._y=0,this._z=0,this._w=1):(e=1/e,this._x*=e,this._y*=e,this._z*=e,this._w*=e),this.onChangeCallback(),this},multiply:function(e,t){return t===void 0?this.multiplyQuaternions(this,e):(console.warn(`THREE.Quaternion: .multiply() now only accepts one argument. Use .multiplyQuaternions( a, b ) instead.`),this.multiplyQuaternions(e,t))},premultiply:function(e){return this.multiplyQuaternions(e,this)},multiplyQuaternions:function(e,t){var n=e._x,r=e._y,i=e._z,a=e._w,o=t._x,s=t._y,c=t._z,l=t._w;return this._x=n*l+a*o+r*c-i*s,this._y=r*l+a*s+i*o-n*c,this._z=i*l+a*c+n*s-r*o,this._w=a*l-n*o-r*s-i*c,this.onChangeCallback(),this},slerp:function(e,t){if(t===0)return this;if(t===1)return this.copy(e);var n=this._x,r=this._y,i=this._z,a=this._w,o=a*e._w+n*e._x+r*e._y+i*e._z;if(o<0?(this._w=-e._w,this._x=-e._x,this._y=-e._y,this._z=-e._z,o=-o):this.copy(e),o>=1)return this._w=a,this._x=n,this._y=r,this._z=i,this;var s=1-o*o;if(s<=2**-52){var c=1-t;return this._w=c*a+t*this._w,this._x=c*n+t*this._x,this._y=c*r+t*this._y,this._z=c*i+t*this._z,this.normalize()}var l=Math.sqrt(s),u=Math.atan2(l,o),d=Math.sin((1-t)*u)/l,f=Math.sin(t*u)/l;return this._w=a*d+this._w*f,this._x=n*d+this._x*f,this._y=r*d+this._y*f,this._z=i*d+this._z*f,this.onChangeCallback(),this},equals:function(e){return e._x===this._x&&e._y===this._y&&e._z===this._z&&e._w===this._w},fromArray:function(e,t){return t===void 0&&(t=0),this._x=e[t],this._y=e[t+1],this._z=e[t+2],this._w=e[t+3],this.onChangeCallback(),this},toArray:function(e,t){return e===void 0&&(e=[]),t===void 0&&(t=0),e[t]=this._x,e[t+1]=this._y,e[t+2]=this._z,e[t+3]=this._w,e},onChange:function(e){return this.onChangeCallback=e,this},onChangeCallback:function(){}});function O(e,t,n){this.x=e||0,this.y=t||0,this.z=n||0}Object.assign(O.prototype,{isVector3:!0,set:function(e,t,n){return this.x=e,this.y=t,this.z=n,this},setScalar:function(e){return this.x=e,this.y=e,this.z=e,this},setX:function(e){return this.x=e,this},setY:function(e){return this.y=e,this},setZ:function(e){return this.z=e,this},setComponent:function(e,t){switch(e){case 0:this.x=t;break;case 1:this.y=t;break;case 2:this.z=t;break;default:throw Error(`index is out of range: `+e)}return this},getComponent:function(e){switch(e){case 0:return this.x;case 1:return this.y;case 2:return this.z;default:throw Error(`index is out of range: `+e)}},clone:function(){return new this.constructor(this.x,this.y,this.z)},copy:function(e){return this.x=e.x,this.y=e.y,this.z=e.z,this},add:function(e,t){return t===void 0?(this.x+=e.x,this.y+=e.y,this.z+=e.z,this):(console.warn(`THREE.Vector3: .add() now only accepts one argument. Use .addVectors( a, b ) instead.`),this.addVectors(e,t))},addScalar:function(e){return this.x+=e,this.y+=e,this.z+=e,this},addVectors:function(e,t){return this.x=e.x+t.x,this.y=e.y+t.y,this.z=e.z+t.z,this},addScaledVector:function(e,t){return this.x+=e.x*t,this.y+=e.y*t,this.z+=e.z*t,this},sub:function(e,t){return t===void 0?(this.x-=e.x,this.y-=e.y,this.z-=e.z,this):(console.warn(`THREE.Vector3: .sub() now only accepts one argument. Use .subVectors( a, b ) instead.`),this.subVectors(e,t))},subScalar:function(e){return this.x-=e,this.y-=e,this.z-=e,this},subVectors:function(e,t){return this.x=e.x-t.x,this.y=e.y-t.y,this.z=e.z-t.z,this},multiply:function(e,t){return t===void 0?(this.x*=e.x,this.y*=e.y,this.z*=e.z,this):(console.warn(`THREE.Vector3: .multiply() now only accepts one argument. Use .multiplyVectors( a, b ) instead.`),this.multiplyVectors(e,t))},multiplyScalar:function(e){return this.x*=e,this.y*=e,this.z*=e,this},multiplyVectors:function(e,t){return this.x=e.x*t.x,this.y=e.y*t.y,this.z=e.z*t.z,this},applyEuler:function(){var e=new D;return function(t){return t&&t.isEuler||console.error(`THREE.Vector3: .applyEuler() now expects an Euler rotation rather than a Vector3 and order.`),this.applyQuaternion(e.setFromEuler(t))}}(),applyAxisAngle:function(){var e=new D;return function(t,n){return this.applyQuaternion(e.setFromAxisAngle(t,n))}}(),applyMatrix3:function(e){var t=this.x,n=this.y,r=this.z,i=e.elements;return this.x=i[0]*t+i[3]*n+i[6]*r,this.y=i[1]*t+i[4]*n+i[7]*r,this.z=i[2]*t+i[5]*n+i[8]*r,this},applyMatrix4:function(e){var t=this.x,n=this.y,r=this.z,i=e.elements,a=1/(i[3]*t+i[7]*n+i[11]*r+i[15]);return this.x=(i[0]*t+i[4]*n+i[8]*r+i[12])*a,this.y=(i[1]*t+i[5]*n+i[9]*r+i[13])*a,this.z=(i[2]*t+i[6]*n+i[10]*r+i[14])*a,this},applyQuaternion:function(e){var t=this.x,n=this.y,r=this.z,i=e.x,a=e.y,o=e.z,s=e.w,c=s*t+a*r-o*n,l=s*n+o*t-i*r,u=s*r+i*n-a*t,d=-i*t-a*n-o*r;return this.x=c*s+d*-i+l*-o-u*-a,this.y=l*s+d*-a+u*-i-c*-o,this.z=u*s+d*-o+c*-a-l*-i,this},project:function(e){return this.applyMatrix4(e.matrixWorldInverse).applyMatrix4(e.projectionMatrix)},unproject:function(){var e=new E;return function(t){return this.applyMatrix4(e.getInverse(t.projectionMatrix)).applyMatrix4(t.matrixWorld)}}(),transformDirection:function(e){var t=this.x,n=this.y,r=this.z,i=e.elements;return this.x=i[0]*t+i[4]*n+i[8]*r,this.y=i[1]*t+i[5]*n+i[9]*r,this.z=i[2]*t+i[6]*n+i[10]*r,this.normalize()},divide:function(e){return this.x/=e.x,this.y/=e.y,this.z/=e.z,this},divideScalar:function(e){return this.multiplyScalar(1/e)},min:function(e){return this.x=Math.min(this.x,e.x),this.y=Math.min(this.y,e.y),this.z=Math.min(this.z,e.z),this},max:function(e){return this.x=Math.max(this.x,e.x),this.y=Math.max(this.y,e.y),this.z=Math.max(this.z,e.z),this},clamp:function(e,t){return this.x=Math.max(e.x,Math.min(t.x,this.x)),this.y=Math.max(e.y,Math.min(t.y,this.y)),this.z=Math.max(e.z,Math.min(t.z,this.z)),this},clampScalar:function(){var e=new O,t=new O;return function(n,r){return e.set(n,n,n),t.set(r,r,r),this.clamp(e,t)}}(),clampLength:function(e,t){var n=this.length();return this.divideScalar(n||1).multiplyScalar(Math.max(e,Math.min(t,n)))},floor:function(){return this.x=Math.floor(this.x),this.y=Math.floor(this.y),this.z=Math.floor(this.z),this},ceil:function(){return this.x=Math.ceil(this.x),this.y=Math.ceil(this.y),this.z=Math.ceil(this.z),this},round:function(){return this.x=Math.round(this.x),this.y=Math.round(this.y),this.z=Math.round(this.z),this},roundToZero:function(){return this.x=this.x<0?Math.ceil(this.x):Math.floor(this.x),this.y=this.y<0?Math.ceil(this.y):Math.floor(this.y),this.z=this.z<0?Math.ceil(this.z):Math.floor(this.z),this},negate:function(){return this.x=-this.x,this.y=-this.y,this.z=-this.z,this},dot:function(e){return this.x*e.x+this.y*e.y+this.z*e.z},lengthSq:function(){return this.x*this.x+this.y*this.y+this.z*this.z},length:function(){return Math.sqrt(this.x*this.x+this.y*this.y+this.z*this.z)},manhattanLength:function(){return Math.abs(this.x)+Math.abs(this.y)+Math.abs(this.z)},normalize:function(){return this.divideScalar(this.length()||1)},setLength:function(e){return this.normalize().multiplyScalar(e)},lerp:function(e,t){return this.x+=(e.x-this.x)*t,this.y+=(e.y-this.y)*t,this.z+=(e.z-this.z)*t,this},lerpVectors:function(e,t,n){return this.subVectors(t,e).multiplyScalar(n).add(e)},cross:function(e,t){return t===void 0?this.crossVectors(this,e):(console.warn(`THREE.Vector3: .cross() now only accepts one argument. Use .crossVectors( a, b ) instead.`),this.crossVectors(e,t))},crossVectors:function(e,t){var n=e.x,r=e.y,i=e.z,a=t.x,o=t.y,s=t.z;return this.x=r*s-i*o,this.y=i*a-n*s,this.z=n*o-r*a,this},projectOnVector:function(e){var t=e.dot(this)/e.lengthSq();return this.copy(e).multiplyScalar(t)},projectOnPlane:function(){var e=new O;return function(t){return e.copy(this).projectOnVector(t),this.sub(e)}}(),reflect:function(){var e=new O;return function(t){return this.sub(e.copy(t).multiplyScalar(2*this.dot(t)))}}(),angleTo:function(e){var t=this.dot(e)/Math.sqrt(this.lengthSq()*e.lengthSq());return Math.acos(w.clamp(t,-1,1))},distanceTo:function(e){return Math.sqrt(this.distanceToSquared(e))},distanceToSquared:function(e){var t=this.x-e.x,n=this.y-e.y,r=this.z-e.z;return t*t+n*n+r*r},manhattanDistanceTo:function(e){return Math.abs(this.x-e.x)+Math.abs(this.y-e.y)+Math.abs(this.z-e.z)},setFromSpherical:function(e){return this.setFromSphericalCoords(e.radius,e.phi,e.theta)},setFromSphericalCoords:function(e,t,n){var r=Math.sin(t)*e;return this.x=r*Math.sin(n),this.y=Math.cos(t)*e,this.z=r*Math.cos(n),this},setFromCylindrical:function(e){return this.setFromCylindricalCoords(e.radius,e.theta,e.y)},setFromCylindricalCoords:function(e,t,n){return this.x=e*Math.sin(t),this.y=n,this.z=e*Math.cos(t),this},setFromMatrixPosition:function(e){var t=e.elements;return this.x=t[12],this.y=t[13],this.z=t[14],this},setFromMatrixScale:function(e){var t=this.setFromMatrixColumn(e,0).length(),n=this.setFromMatrixColumn(e,1).length(),r=this.setFromMatrixColumn(e,2).length();return this.x=t,this.y=n,this.z=r,this},setFromMatrixColumn:function(e,t){return this.fromArray(e.elements,t*4)},equals:function(e){return e.x===this.x&&e.y===this.y&&e.z===this.z},fromArray:function(e,t){return t===void 0&&(t=0),this.x=e[t],this.y=e[t+1],this.z=e[t+2],this},toArray:function(e,t){return e===void 0&&(e=[]),t===void 0&&(t=0),e[t]=this.x,e[t+1]=this.y,e[t+2]=this.z,e},fromBufferAttribute:function(e,t,n){return n!==void 0&&console.warn(`THREE.Vector3: offset has been removed from .fromBufferAttribute().`),this.x=e.getX(t),this.y=e.getY(t),this.z=e.getZ(t),this}});function k(){this.elements=[1,0,0,0,1,0,0,0,1],arguments.length>0&&console.error(`THREE.Matrix3: the constructor no longer reads arguments. use .set() instead.`)}Object.assign(k.prototype,{isMatrix3:!0,set:function(e,t,n,r,i,a,o,s,c){var l=this.elements;return l[0]=e,l[1]=r,l[2]=o,l[3]=t,l[4]=i,l[5]=s,l[6]=n,l[7]=a,l[8]=c,this},identity:function(){return this.set(1,0,0,0,1,0,0,0,1),this},clone:function(){return new this.constructor().fromArray(this.elements)},copy:function(e){var t=this.elements,n=e.elements;return t[0]=n[0],t[1]=n[1],t[2]=n[2],t[3]=n[3],t[4]=n[4],t[5]=n[5],t[6]=n[6],t[7]=n[7],t[8]=n[8],this},setFromMatrix4:function(e){var t=e.elements;return this.set(t[0],t[4],t[8],t[1],t[5],t[9],t[2],t[6],t[10]),this},applyToBufferAttribute:function(){var e=new O;return function(t){for(var n=0,r=t.count;n<r;n++)e.x=t.getX(n),e.y=t.getY(n),e.z=t.getZ(n),e.applyMatrix3(this),t.setXYZ(n,e.x,e.y,e.z);return t}}(),multiply:function(e){return this.multiplyMatrices(this,e)},premultiply:function(e){return this.multiplyMatrices(e,this)},multiplyMatrices:function(e,t){var n=e.elements,r=t.elements,i=this.elements,a=n[0],o=n[3],s=n[6],c=n[1],l=n[4],u=n[7],d=n[2],f=n[5],p=n[8],m=r[0],h=r[3],g=r[6],_=r[1],v=r[4],y=r[7],b=r[2],x=r[5],S=r[8];return i[0]=a*m+o*_+s*b,i[3]=a*h+o*v+s*x,i[6]=a*g+o*y+s*S,i[1]=c*m+l*_+u*b,i[4]=c*h+l*v+u*x,i[7]=c*g+l*y+u*S,i[2]=d*m+f*_+p*b,i[5]=d*h+f*v+p*x,i[8]=d*g+f*y+p*S,this},multiplyScalar:function(e){var t=this.elements;return t[0]*=e,t[3]*=e,t[6]*=e,t[1]*=e,t[4]*=e,t[7]*=e,t[2]*=e,t[5]*=e,t[8]*=e,this},determinant:function(){var e=this.elements,t=e[0],n=e[1],r=e[2],i=e[3],a=e[4],o=e[5],s=e[6],c=e[7],l=e[8];return t*a*l-t*o*c-n*i*l+n*o*s+r*i*c-r*a*s},getInverse:function(e,t){e&&e.isMatrix4&&console.error(`THREE.Matrix3: .getInverse() no longer takes a Matrix4 argument.`);var n=e.elements,r=this.elements,i=n[0],a=n[1],o=n[2],s=n[3],c=n[4],l=n[5],u=n[6],d=n[7],f=n[8],p=f*c-l*d,m=l*u-f*s,h=d*s-c*u,g=i*p+a*m+o*h;if(g===0){var _=`THREE.Matrix3: .getInverse() can't invert matrix, determinant is 0`;if(t===!0)throw Error(_);return console.warn(_),this.identity()}var v=1/g;return r[0]=p*v,r[1]=(o*d-f*a)*v,r[2]=(l*a-o*c)*v,r[3]=m*v,r[4]=(f*i-o*u)*v,r[5]=(o*s-l*i)*v,r[6]=h*v,r[7]=(a*u-d*i)*v,r[8]=(c*i-a*s)*v,this},transpose:function(){var e,t=this.elements;return e=t[1],t[1]=t[3],t[3]=e,e=t[2],t[2]=t[6],t[6]=e,e=t[5],t[5]=t[7],t[7]=e,this},getNormalMatrix:function(e){return this.setFromMatrix4(e).getInverse(this).transpose()},transposeIntoArray:function(e){var t=this.elements;return e[0]=t[0],e[1]=t[3],e[2]=t[6],e[3]=t[1],e[4]=t[4],e[5]=t[7],e[6]=t[2],e[7]=t[5],e[8]=t[8],this},setUvTransform:function(e,t,n,r,i,a,o){var s=Math.cos(i),c=Math.sin(i);this.set(n*s,n*c,-n*(s*a+c*o)+a+e,-r*c,r*s,-r*(-c*a+s*o)+o+t,0,0,1)},scale:function(e,t){var n=this.elements;return n[0]*=e,n[3]*=e,n[6]*=e,n[1]*=t,n[4]*=t,n[7]*=t,this},rotate:function(e){var t=Math.cos(e),n=Math.sin(e),r=this.elements,i=r[0],a=r[3],o=r[6],s=r[1],c=r[4],l=r[7];return r[0]=t*i+n*s,r[3]=t*a+n*c,r[6]=t*o+n*l,r[1]=-n*i+t*s,r[4]=-n*a+t*c,r[7]=-n*o+t*l,this},translate:function(e,t){var n=this.elements;return n[0]+=e*n[2],n[3]+=e*n[5],n[6]+=e*n[8],n[1]+=t*n[2],n[4]+=t*n[5],n[7]+=t*n[8],this},equals:function(e){for(var t=this.elements,n=e.elements,r=0;r<9;r++)if(t[r]!==n[r])return!1;return!0},fromArray:function(e,t){t===void 0&&(t=0);for(var n=0;n<9;n++)this.elements[n]=e[n+t];return this},toArray:function(e,t){e===void 0&&(e=[]),t===void 0&&(t=0);var n=this.elements;return e[t]=n[0],e[t+1]=n[1],e[t+2]=n[2],e[t+3]=n[3],e[t+4]=n[4],e[t+5]=n[5],e[t+6]=n[6],e[t+7]=n[7],e[t+8]=n[8],e}});var A,j={getDataURL:function(e){var t;if(typeof HTMLCanvasElement>`u`)return e.src;if(e instanceof HTMLCanvasElement)t=e;else{A===void 0&&(A=document.createElementNS(`http://www.w3.org/1999/xhtml`,`canvas`)),A.width=e.width,A.height=e.height;var n=A.getContext(`2d`);e instanceof ImageData?n.putImageData(e,0,0):n.drawImage(e,0,0,e.width,e.height),t=A}return t.width>2048||t.height>2048?t.toDataURL(`image/jpeg`,.6):t.toDataURL(`image/png`)}},M=0;function N(e,t,n,r,a,o,u,d,f,p){Object.defineProperty(this,"id",{value:M++}),this.uuid=w.generateUUID(),this.name=``,this.image=e===void 0?N.DEFAULT_IMAGE:e,this.mipmaps=[],this.mapping=t===void 0?N.DEFAULT_MAPPING:t,this.wrapS=n===void 0?i:n,this.wrapT=r===void 0?i:r,this.magFilter=a===void 0?s:a,this.minFilter=o===void 0?c:o,this.anisotropy=f===void 0?1:f,this.format=u===void 0?m:u,this.type=d===void 0?l:d,this.offset=new T(0,0),this.repeat=new T(1,1),this.center=new T(0,0),this.rotation=0,this.matrixAutoUpdate=!0,this.matrix=new k,this.generateMipmaps=!0,this.premultiplyAlpha=!1,this.flipY=!0,this.unpackAlignment=4,this.encoding=p===void 0?h:p,this.version=0,this.onUpdate=null}N.DEFAULT_IMAGE=void 0,N.DEFAULT_MAPPING=300,N.prototype=Object.assign(Object.create(n.prototype),{constructor:N,isTexture:!0,updateMatrix:function(){this.matrix.setUvTransform(this.offset.x,this.offset.y,this.repeat.x,this.repeat.y,this.rotation,this.center.x,this.center.y)},clone:function(){return new this.constructor().copy(this)},copy:function(e){return this.name=e.name,this.image=e.image,this.mipmaps=e.mipmaps.slice(0),this.mapping=e.mapping,this.wrapS=e.wrapS,this.wrapT=e.wrapT,this.magFilter=e.magFilter,this.minFilter=e.minFilter,this.anisotropy=e.anisotropy,this.format=e.format,this.type=e.type,this.offset.copy(e.offset),this.repeat.copy(e.repeat),this.center.copy(e.center),this.rotation=e.rotation,this.matrixAutoUpdate=e.matrixAutoUpdate,this.matrix.copy(e.matrix),this.generateMipmaps=e.generateMipmaps,this.premultiplyAlpha=e.premultiplyAlpha,this.flipY=e.flipY,this.unpackAlignment=e.unpackAlignment,this.encoding=e.encoding,this},toJSON:function(e){var t=e===void 0||typeof e==`string`;if(!t&&e.textures[this.uuid]!==void 0)return e.textures[this.uuid];var n={metadata:{version:4.5,type:`Texture`,generator:`Texture.toJSON`},uuid:this.uuid,name:this.name,mapping:this.mapping,repeat:[this.repeat.x,this.repeat.y],offset:[this.offset.x,this.offset.y],center:[this.center.x,this.center.y],rotation:this.rotation,wrap:[this.wrapS,this.wrapT],format:this.format,type:this.type,encoding:this.encoding,minFilter:this.minFilter,magFilter:this.magFilter,anisotropy:this.anisotropy,flipY:this.flipY,premultiplyAlpha:this.premultiplyAlpha,unpackAlignment:this.unpackAlignment};if(this.image!==void 0){var r=this.image;if(r.uuid===void 0&&(r.uuid=w.generateUUID()),!t&&e.images[r.uuid]===void 0){var i;if(Array.isArray(r)){i=[];for(var a=0,o=r.length;a<o;a++)i.push(j.getDataURL(r[a]))}else i=j.getDataURL(r);e.images[r.uuid]={uuid:r.uuid,url:i}}n.image=r.uuid}return t||(e.textures[this.uuid]=n),n},dispose:function(){this.dispatchEvent({type:`dispose`})},transformUv:function(e){if(this.mapping!==300)return e;if(e.applyMatrix3(this.matrix),e.x<0||e.x>1)switch(this.wrapS){case r:e.x-=Math.floor(e.x);break;case i:e.x=e.x<0?0:1;break;case a:Math.abs(Math.floor(e.x)%2)===1?e.x=Math.ceil(e.x)-e.x:e.x-=Math.floor(e.x);break}if(e.y<0||e.y>1)switch(this.wrapT){case r:e.y-=Math.floor(e.y);break;case i:e.y=e.y<0?0:1;break;case a:Math.abs(Math.floor(e.y)%2)===1?e.y=Math.ceil(e.y)-e.y:e.y-=Math.floor(e.y);break}return this.flipY&&(e.y=1-e.y),e}}),Object.defineProperty(N.prototype,"needsUpdate",{set:function(e){e===!0&&this.version++}});function P(){var e=new Uint8Array(3),t=1,n=1,r=p;N.call(this,null,void 0,void 0,void 0,void 0,void 0,r,void 0,void 0,void 0),this.image={data:e,width:t,height:n},this.magFilter=o,this.minFilter=o,this.generateMipmaps=!1,this.flipY=!1,this.unpackAlignment=1}P.prototype=Object.create(N.prototype),P.prototype.constructor=P,P.prototype.isDataTexture=!0,P.prototype.isCfxTexture=!0;function F(e,t){this.min=e===void 0?new O(1/0,1/0,1/0):e,this.max=t===void 0?new O(-1/0,-1/0,-1/0):t}Object.assign(F.prototype,{isBox3:!0,set:function(e,t){return this.min.copy(e),this.max.copy(t),this},setFromArray:function(e){for(var t=1/0,n=1/0,r=1/0,i=-1/0,a=-1/0,o=-1/0,s=0,c=e.length;s<c;s+=3){var l=e[s],u=e[s+1],d=e[s+2];l<t&&(t=l),u<n&&(n=u),d<r&&(r=d),l>i&&(i=l),u>a&&(a=u),d>o&&(o=d)}return this.min.set(t,n,r),this.max.set(i,a,o),this},setFromBufferAttribute:function(e){for(var t=1/0,n=1/0,r=1/0,i=-1/0,a=-1/0,o=-1/0,s=0,c=e.count;s<c;s++){var l=e.getX(s),u=e.getY(s),d=e.getZ(s);l<t&&(t=l),u<n&&(n=u),d<r&&(r=d),l>i&&(i=l),u>a&&(a=u),d>o&&(o=d)}return this.min.set(t,n,r),this.max.set(i,a,o),this},setFromPoints:function(e){this.makeEmpty();for(var t=0,n=e.length;t<n;t++)this.expandByPoint(e[t]);return this},setFromCenterAndSize:function(){var e=new O;return function(t,n){var r=e.copy(n).multiplyScalar(.5);return this.min.copy(t).sub(r),this.max.copy(t).add(r),this}}(),setFromObject:function(e){return this.makeEmpty(),this.expandByObject(e)},clone:function(){return new this.constructor().copy(this)},copy:function(e){return this.min.copy(e.min),this.max.copy(e.max),this},makeEmpty:function(){return this.min.x=this.min.y=this.min.z=1/0,this.max.x=this.max.y=this.max.z=-1/0,this},isEmpty:function(){return this.max.x<this.min.x||this.max.y<this.min.y||this.max.z<this.min.z},getCenter:function(e){return e===void 0&&(console.warn(`THREE.Box3: .getCenter() target is now required`),e=new O),this.isEmpty()?e.set(0,0,0):e.addVectors(this.min,this.max).multiplyScalar(.5)},getSize:function(e){return e===void 0&&(console.warn(`THREE.Box3: .getSize() target is now required`),e=new O),this.isEmpty()?e.set(0,0,0):e.subVectors(this.max,this.min)},expandByPoint:function(e){return this.min.min(e),this.max.max(e),this},expandByVector:function(e){return this.min.sub(e),this.max.add(e),this},expandByScalar:function(e){return this.min.addScalar(-e),this.max.addScalar(e),this},expandByObject:function(){var e,t,n,r=new O;function i(i){var a=i.geometry;if(a!==void 0){if(a.isGeometry){var o=a.vertices;for(t=0,n=o.length;t<n;t++)r.copy(o[t]),r.applyMatrix4(i.matrixWorld),e.expandByPoint(r)}else if(a.isBufferGeometry){var s=a.attributes.position;if(s!==void 0)for(t=0,n=s.count;t<n;t++)r.fromBufferAttribute(s,t).applyMatrix4(i.matrixWorld),e.expandByPoint(r)}}}return function(t){return e=this,t.updateMatrixWorld(!0),t.traverse(i),this}}(),containsPoint:function(e){return!(e.x<this.min.x||e.x>this.max.x||e.y<this.min.y||e.y>this.max.y||e.z<this.min.z||e.z>this.max.z)},containsBox:function(e){return this.min.x<=e.min.x&&e.max.x<=this.max.x&&this.min.y<=e.min.y&&e.max.y<=this.max.y&&this.min.z<=e.min.z&&e.max.z<=this.max.z},getParameter:function(e,t){return t===void 0&&(console.warn(`THREE.Box3: .getParameter() target is now required`),t=new O),t.set((e.x-this.min.x)/(this.max.x-this.min.x),(e.y-this.min.y)/(this.max.y-this.min.y),(e.z-this.min.z)/(this.max.z-this.min.z))},intersectsBox:function(e){return!(e.max.x<this.min.x||e.min.x>this.max.x||e.max.y<this.min.y||e.min.y>this.max.y||e.max.z<this.min.z||e.min.z>this.max.z)},intersectsSphere:(function(){var e=new O;return function(t){return this.clampPoint(t.center,e),e.distanceToSquared(t.center)<=t.radius*t.radius}})(),intersectsPlane:function(e){var t,n;return e.normal.x>0?(t=e.normal.x*this.min.x,n=e.normal.x*this.max.x):(t=e.normal.x*this.max.x,n=e.normal.x*this.min.x),e.normal.y>0?(t+=e.normal.y*this.min.y,n+=e.normal.y*this.max.y):(t+=e.normal.y*this.max.y,n+=e.normal.y*this.min.y),e.normal.z>0?(t+=e.normal.z*this.min.z,n+=e.normal.z*this.max.z):(t+=e.normal.z*this.max.z,n+=e.normal.z*this.min.z),t<=-e.constant&&n>=-e.constant},intersectsTriangle:(function(){var e=new O,t=new O,n=new O,r=new O,i=new O,a=new O,o=new O,s=new O,c=new O,l=new O;function u(r){var i,a;for(i=0,a=r.length-3;i<=a;i+=3){o.fromArray(r,i);var s=c.x*Math.abs(o.x)+c.y*Math.abs(o.y)+c.z*Math.abs(o.z),l=e.dot(o),u=t.dot(o),d=n.dot(o);if(Math.max(-Math.max(l,u,d),Math.min(l,u,d))>s)return!1}return!0}return function(o){if(this.isEmpty())return!1;this.getCenter(s),c.subVectors(this.max,s),e.subVectors(o.a,s),t.subVectors(o.b,s),n.subVectors(o.c,s),r.subVectors(t,e),i.subVectors(n,t),a.subVectors(e,n);var d=[0,-r.z,r.y,0,-i.z,i.y,0,-a.z,a.y,r.z,0,-r.x,i.z,0,-i.x,a.z,0,-a.x,-r.y,r.x,0,-i.y,i.x,0,-a.y,a.x,0];return!u(d)||(d=[1,0,0,0,1,0,0,0,1],!u(d))?!1:(l.crossVectors(r,i),d=[l.x,l.y,l.z],u(d))}})(),clampPoint:function(e,t){return t===void 0&&(console.warn(`THREE.Box3: .clampPoint() target is now required`),t=new O),t.copy(e).clamp(this.min,this.max)},distanceToPoint:function(){var e=new O;return function(t){return e.copy(t).clamp(this.min,this.max).sub(t).length()}}(),getBoundingSphere:function(){var e=new O;return function(t){return t===void 0&&(console.warn(`THREE.Box3: .getBoundingSphere() target is now required`),t=new I),this.getCenter(t.center),t.radius=this.getSize(e).length()*.5,t}}(),intersect:function(e){return this.min.max(e.min),this.max.min(e.max),this.isEmpty()&&this.makeEmpty(),this},union:function(e){return this.min.min(e.min),this.max.max(e.max),this},applyMatrix4:function(){var e=[new O,new O,new O,new O,new O,new O,new O,new O];return function(t){return this.isEmpty()?this:(e[0].set(this.min.x,this.min.y,this.min.z).applyMatrix4(t),e[1].set(this.min.x,this.min.y,this.max.z).applyMatrix4(t),e[2].set(this.min.x,this.max.y,this.min.z).applyMatrix4(t),e[3].set(this.min.x,this.max.y,this.max.z).applyMatrix4(t),e[4].set(this.max.x,this.min.y,this.min.z).applyMatrix4(t),e[5].set(this.max.x,this.min.y,this.max.z).applyMatrix4(t),e[6].set(this.max.x,this.max.y,this.min.z).applyMatrix4(t),e[7].set(this.max.x,this.max.y,this.max.z).applyMatrix4(t),this.setFromPoints(e),this)}}(),translate:function(e){return this.min.add(e),this.max.add(e),this},equals:function(e){return e.min.equals(this.min)&&e.max.equals(this.max)}});function I(e,t){this.center=e===void 0?new O:e,this.radius=t===void 0?0:t}Object.assign(I.prototype,{set:function(e,t){return this.center.copy(e),this.radius=t,this},setFromPoints:function(){var e=new F;return function(t,n){var r=this.center;n===void 0?e.setFromPoints(t).getCenter(r):r.copy(n);for(var i=0,a=0,o=t.length;a<o;a++)i=Math.max(i,r.distanceToSquared(t[a]));return this.radius=Math.sqrt(i),this}}(),clone:function(){return new this.constructor().copy(this)},copy:function(e){return this.center.copy(e.center),this.radius=e.radius,this},empty:function(){return this.radius<=0},containsPoint:function(e){return e.distanceToSquared(this.center)<=this.radius*this.radius},distanceToPoint:function(e){return e.distanceTo(this.center)-this.radius},intersectsSphere:function(e){var t=this.radius+e.radius;return e.center.distanceToSquared(this.center)<=t*t},intersectsBox:function(e){return e.intersectsSphere(this)},intersectsPlane:function(e){return Math.abs(e.distanceToPoint(this.center))<=this.radius},clampPoint:function(e,t){var n=this.center.distanceToSquared(e);return t===void 0&&(console.warn(`THREE.Sphere: .clampPoint() target is now required`),t=new O),t.copy(e),n>this.radius*this.radius&&(t.sub(this.center).normalize(),t.multiplyScalar(this.radius).add(this.center)),t},getBoundingBox:function(e){return e===void 0&&(console.warn(`THREE.Sphere: .getBoundingBox() target is now required`),e=new F),e.set(this.center,this.center),e.expandByScalar(this.radius),e},applyMatrix4:function(e){return this.center.applyMatrix4(e),this.radius*=e.getMaxScaleOnAxis(),this},translate:function(e){return this.center.add(e),this},equals:function(e){return e.center.equals(this.center)&&e.radius===this.radius}});function L(e,t){this.origin=e===void 0?new O:e,this.direction=t===void 0?new O:t}Object.assign(L.prototype,{set:function(e,t){return this.origin.copy(e),this.direction.copy(t),this},clone:function(){return new this.constructor().copy(this)},copy:function(e){return this.origin.copy(e.origin),this.direction.copy(e.direction),this},at:function(e,t){return t===void 0&&(console.warn(`THREE.Ray: .at() target is now required`),t=new O),t.copy(this.direction).multiplyScalar(e).add(this.origin)},lookAt:function(e){return this.direction.copy(e).sub(this.origin).normalize(),this},recast:function(){var e=new O;return function(t){return this.origin.copy(this.at(t,e)),this}}(),closestPointToPoint:function(e,t){t===void 0&&(console.warn(`THREE.Ray: .closestPointToPoint() target is now required`),t=new O),t.subVectors(e,this.origin);var n=t.dot(this.direction);return n<0?t.copy(this.origin):t.copy(this.direction).multiplyScalar(n).add(this.origin)},distanceToPoint:function(e){return Math.sqrt(this.distanceSqToPoint(e))},distanceSqToPoint:function(){var e=new O;return function(t){var n=e.subVectors(t,this.origin).dot(this.direction);return n<0?this.origin.distanceToSquared(t):(e.copy(this.direction).multiplyScalar(n).add(this.origin),e.distanceToSquared(t))}}(),distanceSqToSegment:function(){var e=new O,t=new O,n=new O;return function(r,i,a,o){e.copy(r).add(i).multiplyScalar(.5),t.copy(i).sub(r).normalize(),n.copy(this.origin).sub(e);var s=r.distanceTo(i)*.5,c=-this.direction.dot(t),l=n.dot(this.direction),u=-n.dot(t),d=n.lengthSq(),f=Math.abs(1-c*c),p,m,h,g;if(f>0)if(p=c*u-l,m=c*l-u,g=s*f,p>=0)if(m>=-g)if(m<=g){var _=1/f;p*=_,m*=_,h=p*(p+c*m+2*l)+m*(c*p+m+2*u)+d}else m=s,p=Math.max(0,-(c*m+l)),h=-p*p+m*(m+2*u)+d;else m=-s,p=Math.max(0,-(c*m+l)),h=-p*p+m*(m+2*u)+d;else m<=-g?(p=Math.max(0,-(-c*s+l)),m=p>0?-s:Math.min(Math.max(-s,-u),s),h=-p*p+m*(m+2*u)+d):m<=g?(p=0,m=Math.min(Math.max(-s,-u),s),h=m*(m+2*u)+d):(p=Math.max(0,-(c*s+l)),m=p>0?s:Math.min(Math.max(-s,-u),s),h=-p*p+m*(m+2*u)+d);else m=c>0?-s:s,p=Math.max(0,-(c*m+l)),h=-p*p+m*(m+2*u)+d;return a&&a.copy(this.direction).multiplyScalar(p).add(this.origin),o&&o.copy(t).multiplyScalar(m).add(e),h}}(),intersectSphere:function(){var e=new O;return function(t,n){e.subVectors(t.center,this.origin);var r=e.dot(this.direction),i=e.dot(e)-r*r,a=t.radius*t.radius;if(i>a)return null;var o=Math.sqrt(a-i),s=r-o,c=r+o;return s<0&&c<0?null:s<0?this.at(c,n):this.at(s,n)}}(),intersectsSphere:function(e){return this.distanceSqToPoint(e.center)<=e.radius*e.radius},distanceToPlane:function(e){var t=e.normal.dot(this.direction);if(t===0)return e.distanceToPoint(this.origin)===0?0:null;var n=-(this.origin.dot(e.normal)+e.constant)/t;return n>=0?n:null},intersectPlane:function(e,t){var n=this.distanceToPlane(e);return n===null?null:this.at(n,t)},intersectsPlane:function(e){var t=e.distanceToPoint(this.origin);return t===0||e.normal.dot(this.direction)*t<0},intersectBox:function(e,t){var n,r,i,a,o,s,c=1/this.direction.x,l=1/this.direction.y,u=1/this.direction.z,d=this.origin;return c>=0?(n=(e.min.x-d.x)*c,r=(e.max.x-d.x)*c):(n=(e.max.x-d.x)*c,r=(e.min.x-d.x)*c),l>=0?(i=(e.min.y-d.y)*l,a=(e.max.y-d.y)*l):(i=(e.max.y-d.y)*l,a=(e.min.y-d.y)*l),n>a||i>r||((i>n||n!==n)&&(n=i),(a<r||r!==r)&&(r=a),u>=0?(o=(e.min.z-d.z)*u,s=(e.max.z-d.z)*u):(o=(e.max.z-d.z)*u,s=(e.min.z-d.z)*u),n>s||o>r)||((o>n||n!==n)&&(n=o),(s<r||r!==r)&&(r=s),r<0)?null:this.at(n>=0?n:r,t)},intersectsBox:(function(){var e=new O;return function(t){return this.intersectBox(t,e)!==null}})(),intersectTriangle:function(){var e=new O,t=new O,n=new O,r=new O;return function(i,a,o,s,c){t.subVectors(a,i),n.subVectors(o,i),r.crossVectors(t,n);var l=this.direction.dot(r),u;if(l>0){if(s)return null;u=1}else if(l<0)u=-1,l=-l;else return null;e.subVectors(this.origin,i);var d=u*this.direction.dot(n.crossVectors(e,n));if(d<0)return null;var f=u*this.direction.dot(t.cross(e));if(f<0||d+f>l)return null;var p=-u*e.dot(r);return p<0?null:this.at(p/l,c)}}(),applyMatrix4:function(e){return this.origin.applyMatrix4(e),this.direction.transformDirection(e),this},equals:function(e){return e.origin.equals(this.origin)&&e.direction.equals(this.direction)}});function R(e,t,n,r){this._x=e||0,this._y=t||0,this._z=n||0,this._order=r||R.DefaultOrder}R.RotationOrders=[`XYZ`,`YZX`,`ZXY`,`XZY`,`YXZ`,`ZYX`],R.DefaultOrder=`XYZ`,Object.defineProperties(R.prototype,{x:{get:function(){return this._x},set:function(e){this._x=e,this.onChangeCallback()}},y:{get:function(){return this._y},set:function(e){this._y=e,this.onChangeCallback()}},z:{get:function(){return this._z},set:function(e){this._z=e,this.onChangeCallback()}},order:{get:function(){return this._order},set:function(e){this._order=e,this.onChangeCallback()}}}),Object.assign(R.prototype,{isEuler:!0,set:function(e,t,n,r){return this._x=e,this._y=t,this._z=n,this._order=r||this._order,this.onChangeCallback(),this},clone:function(){return new this.constructor(this._x,this._y,this._z,this._order)},copy:function(e){return this._x=e._x,this._y=e._y,this._z=e._z,this._order=e._order,this.onChangeCallback(),this},setFromRotationMatrix:function(e,t,n){var r=w.clamp,i=e.elements,a=i[0],o=i[4],s=i[8],c=i[1],l=i[5],u=i[9],d=i[2],f=i[6],p=i[10];return t||=this._order,t===`XYZ`?(this._y=Math.asin(r(s,-1,1)),Math.abs(s)<.99999?(this._x=Math.atan2(-u,p),this._z=Math.atan2(-o,a)):(this._x=Math.atan2(f,l),this._z=0)):t===`YXZ`?(this._x=Math.asin(-r(u,-1,1)),Math.abs(u)<.99999?(this._y=Math.atan2(s,p),this._z=Math.atan2(c,l)):(this._y=Math.atan2(-d,a),this._z=0)):t===`ZXY`?(this._x=Math.asin(r(f,-1,1)),Math.abs(f)<.99999?(this._y=Math.atan2(-d,p),this._z=Math.atan2(-o,l)):(this._y=0,this._z=Math.atan2(c,a))):t===`ZYX`?(this._y=Math.asin(-r(d,-1,1)),Math.abs(d)<.99999?(this._x=Math.atan2(f,p),this._z=Math.atan2(c,a)):(this._x=0,this._z=Math.atan2(-o,l))):t===`YZX`?(this._z=Math.asin(r(c,-1,1)),Math.abs(c)<.99999?(this._x=Math.atan2(-u,l),this._y=Math.atan2(-d,a)):(this._x=0,this._y=Math.atan2(s,p))):t===`XZY`?(this._z=Math.asin(-r(o,-1,1)),Math.abs(o)<.99999?(this._x=Math.atan2(f,l),this._y=Math.atan2(s,a)):(this._x=Math.atan2(-u,p),this._y=0)):console.warn(`THREE.Euler: .setFromRotationMatrix() given unsupported order: `+t),this._order=t,n!==!1&&this.onChangeCallback(),this},setFromQuaternion:function(){var e=new E;return function(t,n,r){return e.makeRotationFromQuaternion(t),this.setFromRotationMatrix(e,n,r)}}(),setFromVector3:function(e,t){return this.set(e.x,e.y,e.z,t||this._order)},reorder:function(){var e=new D;return function(t){return e.setFromEuler(this),this.setFromQuaternion(e,t)}}(),equals:function(e){return e._x===this._x&&e._y===this._y&&e._z===this._z&&e._order===this._order},fromArray:function(e){return this._x=e[0],this._y=e[1],this._z=e[2],e[3]!==void 0&&(this._order=e[3]),this.onChangeCallback(),this},toArray:function(e,t){return e===void 0&&(e=[]),t===void 0&&(t=0),e[t]=this._x,e[t+1]=this._y,e[t+2]=this._z,e[t+3]=this._order,e},toVector3:function(e){return e?e.set(this._x,this._y,this._z):new O(this._x,this._y,this._z)},onChange:function(e){return this.onChangeCallback=e,this},onChangeCallback:function(){}});function ee(){this.mask=1}Object.assign(ee.prototype,{set:function(e){this.mask=1<<e|0},enable:function(e){this.mask|=1<<e|0},toggle:function(e){this.mask^=1<<e|0},disable:function(e){this.mask&=~(1<<e|0)},test:function(e){return(this.mask&e.mask)!==0}});var te=0;function z(){Object.defineProperty(this,"id",{value:te++}),this.uuid=w.generateUUID(),this.name=``,this.type=`Object3D`,this.parent=null,this.children=[],this.up=z.DefaultUp.clone();var e=new O,t=new R,n=new D,r=new O(1,1,1);function i(){n.setFromEuler(t,!1)}function a(){t.setFromQuaternion(n,void 0,!1)}t.onChange(i),n.onChange(a),Object.defineProperties(this,{position:{configurable:!0,enumerable:!0,value:e},rotation:{configurable:!0,enumerable:!0,value:t},quaternion:{configurable:!0,enumerable:!0,value:n},scale:{configurable:!0,enumerable:!0,value:r},modelViewMatrix:{value:new E},normalMatrix:{value:new k}}),this.matrix=new E,this.matrixWorld=new E,this.matrixAutoUpdate=z.DefaultMatrixAutoUpdate,this.matrixWorldNeedsUpdate=!1,this.layers=new ee,this.visible=!0,this.castShadow=!1,this.receiveShadow=!1,this.frustumCulled=!0,this.renderOrder=0,this.userData={}}z.DefaultUp=new O(0,1,0),z.DefaultMatrixAutoUpdate=!0,z.prototype=Object.assign(Object.create(n.prototype),{constructor:z,isObject3D:!0,onBeforeRender:function(){},onAfterRender:function(){},applyMatrix:function(e){this.matrix.multiplyMatrices(e,this.matrix),this.matrix.decompose(this.position,this.quaternion,this.scale)},applyQuaternion:function(e){return this.quaternion.premultiply(e),this},setRotationFromAxisAngle:function(e,t){this.quaternion.setFromAxisAngle(e,t)},setRotationFromEuler:function(e){this.quaternion.setFromEuler(e,!0)},setRotationFromMatrix:function(e){this.quaternion.setFromRotationMatrix(e)},setRotationFromQuaternion:function(e){this.quaternion.copy(e)},rotateOnAxis:function(){var e=new D;return function(t,n){return e.setFromAxisAngle(t,n),this.quaternion.multiply(e),this}}(),rotateOnWorldAxis:function(){var e=new D;return function(t,n){return e.setFromAxisAngle(t,n),this.quaternion.premultiply(e),this}}(),rotateX:function(){var e=new O(1,0,0);return function(t){return this.rotateOnAxis(e,t)}}(),rotateY:function(){var e=new O(0,1,0);return function(t){return this.rotateOnAxis(e,t)}}(),rotateZ:function(){var e=new O(0,0,1);return function(t){return this.rotateOnAxis(e,t)}}(),translateOnAxis:function(){var e=new O;return function(t,n){return e.copy(t).applyQuaternion(this.quaternion),this.position.add(e.multiplyScalar(n)),this}}(),translateX:function(){var e=new O(1,0,0);return function(t){return this.translateOnAxis(e,t)}}(),translateY:function(){var e=new O(0,1,0);return function(t){return this.translateOnAxis(e,t)}}(),translateZ:function(){var e=new O(0,0,1);return function(t){return this.translateOnAxis(e,t)}}(),localToWorld:function(e){return e.applyMatrix4(this.matrixWorld)},worldToLocal:function(){var e=new E;return function(t){return t.applyMatrix4(e.getInverse(this.matrixWorld))}}(),lookAt:function(){var e=new D,t=new E,n=new O,r=new O;return function(i,a,o){i.isVector3?n.copy(i):n.set(i,a,o);var s=this.parent;this.updateWorldMatrix(!0,!1),r.setFromMatrixPosition(this.matrixWorld),this.isCamera||this.isLight?t.lookAt(r,n,this.up):t.lookAt(n,r,this.up),this.quaternion.setFromRotationMatrix(t),s&&(t.extractRotation(s.matrixWorld),e.setFromRotationMatrix(t),this.quaternion.premultiply(e.inverse()))}}(),add:function(e){if(arguments.length>1){for(var t=0;t<arguments.length;t++)this.add(arguments[t]);return this}return e===this?(console.error(`THREE.Object3D.add: object can't be added as a child of itself.`,e),this):(e&&e.isObject3D?(e.parent!==null&&e.parent.remove(e),e.parent=this,e.dispatchEvent({type:`added`}),this.children.push(e)):console.error(`THREE.Object3D.add: object not an instance of THREE.Object3D.`,e),this)},remove:function(e){if(arguments.length>1){for(var t=0;t<arguments.length;t++)this.remove(arguments[t]);return this}var n=this.children.indexOf(e);return n!==-1&&(e.parent=null,e.dispatchEvent({type:`removed`}),this.children.splice(n,1)),this},getObjectById:function(e){return this.getObjectByProperty(`id`,e)},getObjectByName:function(e){return this.getObjectByProperty(`name`,e)},getObjectByProperty:function(e,t){if(this[e]===t)return this;for(var n=0,r=this.children.length;n<r;n++){var i=this.children[n].getObjectByProperty(e,t);if(i!==void 0)return i}},getWorldPosition:function(e){return e===void 0&&(console.warn(`THREE.Object3D: .getWorldPosition() target is now required`),e=new O),this.updateMatrixWorld(!0),e.setFromMatrixPosition(this.matrixWorld)},getWorldQuaternion:function(){var e=new O,t=new O;return function(n){return n===void 0&&(console.warn(`THREE.Object3D: .getWorldQuaternion() target is now required`),n=new D),this.updateMatrixWorld(!0),this.matrixWorld.decompose(e,n,t),n}}(),getWorldScale:function(){var e=new O,t=new D;return function(n){return n===void 0&&(console.warn(`THREE.Object3D: .getWorldScale() target is now required`),n=new O),this.updateMatrixWorld(!0),this.matrixWorld.decompose(e,t,n),n}}(),getWorldDirection:function(e){e===void 0&&(console.warn(`THREE.Object3D: .getWorldDirection() target is now required`),e=new O),this.updateMatrixWorld(!0);var t=this.matrixWorld.elements;return e.set(t[8],t[9],t[10]).normalize()},raycast:function(){},traverse:function(e){e(this);for(var t=this.children,n=0,r=t.length;n<r;n++)t[n].traverse(e)},traverseVisible:function(e){if(this.visible!==!1){e(this);for(var t=this.children,n=0,r=t.length;n<r;n++)t[n].traverseVisible(e)}},traverseAncestors:function(e){var t=this.parent;t!==null&&(e(t),t.traverseAncestors(e))},updateMatrix:function(){this.matrix.compose(this.position,this.quaternion,this.scale),this.matrixWorldNeedsUpdate=!0},updateMatrixWorld:function(e){this.matrixAutoUpdate&&this.updateMatrix(),(this.matrixWorldNeedsUpdate||e)&&(this.parent===null?this.matrixWorld.copy(this.matrix):this.matrixWorld.multiplyMatrices(this.parent.matrixWorld,this.matrix),this.matrixWorldNeedsUpdate=!1,e=!0);for(var t=this.children,n=0,r=t.length;n<r;n++)t[n].updateMatrixWorld(e)},updateWorldMatrix:function(e,t){var n=this.parent;if(e===!0&&n!==null&&n.updateWorldMatrix(!0,!1),this.matrixAutoUpdate&&this.updateMatrix(),this.parent===null?this.matrixWorld.copy(this.matrix):this.matrixWorld.multiplyMatrices(this.parent.matrixWorld,this.matrix),t===!0)for(var r=this.children,i=0,a=r.length;i<a;i++)r[i].updateWorldMatrix(!1,!0)},toJSON:function(e){var t=e===void 0||typeof e==`string`,n={};t&&(e={geometries:{},materials:{},textures:{},images:{},shapes:{}},n.metadata={version:4.5,type:`Object`,generator:`Object3D.toJSON`});var r={};r.uuid=this.uuid,r.type=this.type,this.name!==``&&(r.name=this.name),this.castShadow===!0&&(r.castShadow=!0),this.receiveShadow===!0&&(r.receiveShadow=!0),this.visible===!1&&(r.visible=!1),this.frustumCulled===!1&&(r.frustumCulled=!1),this.renderOrder!==0&&(r.renderOrder=this.renderOrder),JSON.stringify(this.userData)!==`{}`&&(r.userData=this.userData),r.layers=this.layers.mask,r.matrix=this.matrix.toArray(),this.matrixAutoUpdate===!1&&(r.matrixAutoUpdate=!1);function i(t,n){return t[n.uuid]===void 0&&(t[n.uuid]=n.toJSON(e)),n.uuid}if(this.isMesh||this.isLine||this.isPoints){r.geometry=i(e.geometries,this.geometry);var a=this.geometry.parameters;if(a!==void 0&&a.shapes!==void 0){var o=a.shapes;if(Array.isArray(o))for(var s=0,c=o.length;s<c;s++){var l=o[s];i(e.shapes,l)}else i(e.shapes,o)}}if(this.material!==void 0)if(Array.isArray(this.material)){for(var u=[],s=0,c=this.material.length;s<c;s++)u.push(i(e.materials,this.material[s]));r.material=u}else r.material=i(e.materials,this.material);if(this.children.length>0){r.children=[];for(var s=0;s<this.children.length;s++)r.children.push(this.children[s].toJSON(e).object)}if(t){var d=h(e.geometries),f=h(e.materials),p=h(e.textures),m=h(e.images),o=h(e.shapes);d.length>0&&(n.geometries=d),f.length>0&&(n.materials=f),p.length>0&&(n.textures=p),m.length>0&&(n.images=m),o.length>0&&(n.shapes=o)}return n.object=r,n;function h(e){var t=[];for(var n in e){var r=e[n];delete r.metadata,t.push(r)}return t}},clone:function(e){return new this.constructor().copy(this,e)},copy:function(e,t){if(t===void 0&&(t=!0),this.name=e.name,this.up.copy(e.up),this.position.copy(e.position),this.quaternion.copy(e.quaternion),this.scale.copy(e.scale),this.matrix.copy(e.matrix),this.matrixWorld.copy(e.matrixWorld),this.matrixAutoUpdate=e.matrixAutoUpdate,this.matrixWorldNeedsUpdate=e.matrixWorldNeedsUpdate,this.layers.mask=e.layers.mask,this.visible=e.visible,this.castShadow=e.castShadow,this.receiveShadow=e.receiveShadow,this.frustumCulled=e.frustumCulled,this.renderOrder=e.renderOrder,this.userData=JSON.parse(JSON.stringify(e.userData)),t===!0)for(var n=0;n<e.children.length;n++){var r=e.children[n];this.add(r.clone())}return this}});function ne(e,t,n){this.a=e===void 0?new O:e,this.b=t===void 0?new O:t,this.c=n===void 0?new O:n}Object.assign(ne,{getNormal:function(){var e=new O;return function(t,n,r,i){i===void 0&&(console.warn(`THREE.Triangle: .getNormal() target is now required`),i=new O),i.subVectors(r,n),e.subVectors(t,n),i.cross(e);var a=i.lengthSq();return a>0?i.multiplyScalar(1/Math.sqrt(a)):i.set(0,0,0)}}(),getBarycoord:function(){var e=new O,t=new O,n=new O;return function(r,i,a,o,s){e.subVectors(o,i),t.subVectors(a,i),n.subVectors(r,i);var c=e.dot(e),l=e.dot(t),u=e.dot(n),d=t.dot(t),f=t.dot(n),p=c*d-l*l;if(s===void 0&&(console.warn(`THREE.Triangle: .getBarycoord() target is now required`),s=new O),p===0)return s.set(-2,-1,-1);var m=1/p,h=(d*u-l*f)*m,g=(c*f-l*u)*m;return s.set(1-h-g,g,h)}}(),containsPoint:function(){var e=new O;return function(t,n,r,i){return ne.getBarycoord(t,n,r,i,e),e.x>=0&&e.y>=0&&e.x+e.y<=1}}(),getUV:function(){var e=new O;return function(t,n,r,i,a,o,s,c){return this.getBarycoord(t,n,r,i,e),c.set(0,0),c.addScaledVector(a,e.x),c.addScaledVector(o,e.y),c.addScaledVector(s,e.z),c}}()}),Object.assign(ne.prototype,{set:function(e,t,n){return this.a.copy(e),this.b.copy(t),this.c.copy(n),this},setFromPointsAndIndices:function(e,t,n,r){return this.a.copy(e[t]),this.b.copy(e[n]),this.c.copy(e[r]),this},clone:function(){return new this.constructor().copy(this)},copy:function(e){return this.a.copy(e.a),this.b.copy(e.b),this.c.copy(e.c),this},getArea:function(){var e=new O,t=new O;return function(){return e.subVectors(this.c,this.b),t.subVectors(this.a,this.b),e.cross(t).length()*.5}}(),getMidpoint:function(e){return e===void 0&&(console.warn(`THREE.Triangle: .getMidpoint() target is now required`),e=new O),e.addVectors(this.a,this.b).add(this.c).multiplyScalar(1/3)},getNormal:function(e){return ne.getNormal(this.a,this.b,this.c,e)},getPlane:function(e){return e===void 0&&(console.warn(`THREE.Triangle: .getPlane() target is now required`),e=new O),e.setFromCoplanarPoints(this.a,this.b,this.c)},getBarycoord:function(e,t){return ne.getBarycoord(e,this.a,this.b,this.c,t)},containsPoint:function(e){return ne.containsPoint(e,this.a,this.b,this.c)},getUV:function(e,t,n,r,i){return ne.getUV(e,this.a,this.b,this.c,t,n,r,i)},intersectsBox:function(e){return e.intersectsTriangle(this)},closestPointToPoint:function(){var e=new O,t=new O,n=new O,r=new O,i=new O,a=new O;return function(o,s){s===void 0&&(console.warn(`THREE.Triangle: .closestPointToPoint() target is now required`),s=new O);var c=this.a,l=this.b,u=this.c,d,f;e.subVectors(l,c),t.subVectors(u,c),r.subVectors(o,c);var p=e.dot(r),m=t.dot(r);if(p<=0&&m<=0)return s.copy(c);i.subVectors(o,l);var h=e.dot(i),g=t.dot(i);if(h>=0&&g<=h)return s.copy(l);var _=p*g-h*m;if(_<=0&&p>=0&&h<=0)return d=p/(p-h),s.copy(c).addScaledVector(e,d);a.subVectors(o,u);var v=e.dot(a),y=t.dot(a);if(y>=0&&v<=y)return s.copy(u);var b=v*m-p*y;if(b<=0&&m>=0&&y<=0)return f=m/(m-y),s.copy(c).addScaledVector(t,f);var x=h*y-v*g;if(x<=0&&g-h>=0&&v-y>=0)return n.subVectors(u,l),f=(g-h)/(g-h+(v-y)),s.copy(l).addScaledVector(n,f);var S=1/(x+b+_);return d=b*S,f=_*S,s.copy(c).addScaledVector(e,d).addScaledVector(t,f)}}(),equals:function(e){return e.a.equals(this.a)&&e.b.equals(this.b)&&e.c.equals(this.c)}});var B={aliceblue:15792383,antiquewhite:16444375,aqua:65535,aquamarine:8388564,azure:15794175,beige:16119260,bisque:16770244,black:0,blanchedalmond:16772045,blue:255,blueviolet:9055202,brown:10824234,burlywood:14596231,cadetblue:6266528,chartreuse:8388352,chocolate:13789470,coral:16744272,cornflowerblue:6591981,cornsilk:16775388,crimson:14423100,cyan:65535,darkblue:139,darkcyan:35723,darkgoldenrod:12092939,darkgray:11119017,darkgreen:25600,darkgrey:11119017,darkkhaki:12433259,darkmagenta:9109643,darkolivegreen:5597999,darkorange:16747520,darkorchid:10040012,darkred:9109504,darksalmon:15308410,darkseagreen:9419919,darkslateblue:4734347,darkslategray:3100495,darkslategrey:3100495,darkturquoise:52945,darkviolet:9699539,deeppink:16716947,deepskyblue:49151,dimgray:6908265,dimgrey:6908265,dodgerblue:2003199,firebrick:11674146,floralwhite:16775920,forestgreen:2263842,fuchsia:16711935,gainsboro:14474460,ghostwhite:16316671,gold:16766720,goldenrod:14329120,gray:8421504,green:32768,greenyellow:11403055,grey:8421504,honeydew:15794160,hotpink:16738740,indianred:13458524,indigo:4915330,ivory:16777200,khaki:15787660,lavender:15132410,lavenderblush:16773365,lawngreen:8190976,lemonchiffon:16775885,lightblue:11393254,lightcoral:15761536,lightcyan:14745599,lightgoldenrodyellow:16448210,lightgray:13882323,lightgreen:9498256,lightgrey:13882323,lightpink:16758465,lightsalmon:16752762,lightseagreen:2142890,lightskyblue:8900346,lightslategray:7833753,lightslategrey:7833753,lightsteelblue:11584734,lightyellow:16777184,lime:65280,limegreen:3329330,linen:16445670,magenta:16711935,maroon:8388608,mediumaquamarine:6737322,mediumblue:205,mediumorchid:12211667,mediumpurple:9662683,mediumseagreen:3978097,mediumslateblue:8087790,mediumspringgreen:64154,mediumturquoise:4772300,mediumvioletred:13047173,midnightblue:1644912,mintcream:16121850,mistyrose:16770273,moccasin:16770229,navajowhite:16768685,navy:128,oldlace:16643558,olive:8421376,olivedrab:7048739,orange:16753920,orangered:16729344,orchid:14315734,palegoldenrod:15657130,palegreen:10025880,paleturquoise:11529966,palevioletred:14381203,papayawhip:16773077,peachpuff:16767673,peru:13468991,pink:16761035,plum:14524637,powderblue:11591910,purple:8388736,rebeccapurple:6697881,red:16711680,rosybrown:12357519,royalblue:4286945,saddlebrown:9127187,salmon:16416882,sandybrown:16032864,seagreen:3050327,seashell:16774638,sienna:10506797,silver:12632256,skyblue:8900331,slateblue:6970061,slategray:7372944,slategrey:7372944,snow:16775930,springgreen:65407,steelblue:4620980,tan:13808780,teal:32896,thistle:14204888,tomato:16737095,turquoise:4251856,violet:15631086,wheat:16113331,white:16777215,whitesmoke:16119285,yellow:16776960,yellowgreen:10145074};function V(e,t,n){return t===void 0&&n===void 0?this.set(e):this.setRGB(e,t,n)}Object.assign(V.prototype,{isColor:!0,r:1,g:1,b:1,set:function(e){return e&&e.isColor?this.copy(e):typeof e==`number`?this.setHex(e):typeof e==`string`&&this.setStyle(e),this},setScalar:function(e){return this.r=e,this.g=e,this.b=e,this},setHex:function(e){return e=Math.floor(e),this.r=(e>>16&255)/255,this.g=(e>>8&255)/255,this.b=(e&255)/255,this},setRGB:function(e,t,n){return this.r=e,this.g=t,this.b=n,this},setHSL:function(){function e(e,t,n){return n<0&&(n+=1),n>1&&--n,n<1/6?e+(t-e)*6*n:n<1/2?t:n<2/3?e+(t-e)*6*(2/3-n):e}return function(t,n,r){if(t=w.euclideanModulo(t,1),n=w.clamp(n,0,1),r=w.clamp(r,0,1),n===0)this.r=this.g=this.b=r;else{var i=r<=.5?r*(1+n):r+n-r*n,a=2*r-i;this.r=e(a,i,t+1/3),this.g=e(a,i,t),this.b=e(a,i,t-1/3)}return this}}(),setStyle:function(e){function t(t){t!==void 0&&parseFloat(t)<1&&console.warn(`THREE.Color: Alpha component of `+e+` will be ignored.`)}var n;if(n=/^((?:rgb|hsl)a?)\(\s*([^\)]*)\)/.exec(e)){var r,i=n[1],a=n[2];switch(i){case`rgb`:case`rgba`:if(r=/^(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*(,\s*([0-9]*\.?[0-9]+)\s*)?$/.exec(a))return this.r=Math.min(255,parseInt(r[1],10))/255,this.g=Math.min(255,parseInt(r[2],10))/255,this.b=Math.min(255,parseInt(r[3],10))/255,t(r[5]),this;if(r=/^(\d+)\%\s*,\s*(\d+)\%\s*,\s*(\d+)\%\s*(,\s*([0-9]*\.?[0-9]+)\s*)?$/.exec(a))return this.r=Math.min(100,parseInt(r[1],10))/100,this.g=Math.min(100,parseInt(r[2],10))/100,this.b=Math.min(100,parseInt(r[3],10))/100,t(r[5]),this;break;case`hsl`:case`hsla`:if(r=/^([0-9]*\.?[0-9]+)\s*,\s*(\d+)\%\s*,\s*(\d+)\%\s*(,\s*([0-9]*\.?[0-9]+)\s*)?$/.exec(a)){var o=parseFloat(r[1])/360,s=parseInt(r[2],10)/100,c=parseInt(r[3],10)/100;return t(r[5]),this.setHSL(o,s,c)}break}}else if(n=/^\#([A-Fa-f0-9]+)$/.exec(e)){var l=n[1],u=l.length;if(u===3)return this.r=parseInt(l.charAt(0)+l.charAt(0),16)/255,this.g=parseInt(l.charAt(1)+l.charAt(1),16)/255,this.b=parseInt(l.charAt(2)+l.charAt(2),16)/255,this;if(u===6)return this.r=parseInt(l.charAt(0)+l.charAt(1),16)/255,this.g=parseInt(l.charAt(2)+l.charAt(3),16)/255,this.b=parseInt(l.charAt(4)+l.charAt(5),16)/255,this}if(e&&e.length>0){var l=B[e];l===void 0?console.warn(`THREE.Color: Unknown color `+e):this.setHex(l)}return this},clone:function(){return new this.constructor(this.r,this.g,this.b)},copy:function(e){return this.r=e.r,this.g=e.g,this.b=e.b,this},copyGammaToLinear:function(e,t){return t===void 0&&(t=2),this.r=e.r**+t,this.g=e.g**+t,this.b=e.b**+t,this},copyLinearToGamma:function(e,t){t===void 0&&(t=2);var n=t>0?1/t:1;return this.r=e.r**+n,this.g=e.g**+n,this.b=e.b**+n,this},convertGammaToLinear:function(e){return this.copyGammaToLinear(this,e),this},convertLinearToGamma:function(e){return this.copyLinearToGamma(this,e),this},copySRGBToLinear:function(){function e(e){return e<.04045?e*.0773993808:(e*.9478672986+.0521327014)**2.4}return function(t){return this.r=e(t.r),this.g=e(t.g),this.b=e(t.b),this}}(),copyLinearToSRGB:function(){function e(e){return e<.0031308?e*12.92:1.055*e**.41666-.055}return function(t){return this.r=e(t.r),this.g=e(t.g),this.b=e(t.b),this}}(),convertSRGBToLinear:function(){return this.copySRGBToLinear(this),this},convertLinearToSRGB:function(){return this.copyLinearToSRGB(this),this},getHex:function(){return this.r*255<<16^this.g*255<<8^this.b*255<<0},getHexString:function(){return(`000000`+this.getHex().toString(16)).slice(-6)},getHSL:function(e){e===void 0&&(console.warn(`THREE.Color: .getHSL() target is now required`),e={h:0,s:0,l:0});var t=this.r,n=this.g,r=this.b,i=Math.max(t,n,r),a=Math.min(t,n,r),o,s,c=(a+i)/2;if(a===i)o=0,s=0;else{var l=i-a;switch(s=c<=.5?l/(i+a):l/(2-i-a),i){case t:o=(n-r)/l+(n<r?6:0);break;case n:o=(r-t)/l+2;break;case r:o=(t-n)/l+4;break}o/=6}return e.h=o,e.s=s,e.l=c,e},getStyle:function(){return`rgb(`+(this.r*255|0)+`,`+(this.g*255|0)+`,`+(this.b*255|0)+`)`},offsetHSL:function(){var e={};return function(t,n,r){return this.getHSL(e),e.h+=t,e.s+=n,e.l+=r,this.setHSL(e.h,e.s,e.l),this}}(),add:function(e){return this.r+=e.r,this.g+=e.g,this.b+=e.b,this},addColors:function(e,t){return this.r=e.r+t.r,this.g=e.g+t.g,this.b=e.b+t.b,this},addScalar:function(e){return this.r+=e,this.g+=e,this.b+=e,this},sub:function(e){return this.r=Math.max(0,this.r-e.r),this.g=Math.max(0,this.g-e.g),this.b=Math.max(0,this.b-e.b),this},multiply:function(e){return this.r*=e.r,this.g*=e.g,this.b*=e.b,this},multiplyScalar:function(e){return this.r*=e,this.g*=e,this.b*=e,this},lerp:function(e,t){return this.r+=(e.r-this.r)*t,this.g+=(e.g-this.g)*t,this.b+=(e.b-this.b)*t,this},lerpHSL:function(){var e={h:0,s:0,l:0},t={h:0,s:0,l:0};return function(n,r){this.getHSL(e),n.getHSL(t);var i=w.lerp(e.h,t.h,r),a=w.lerp(e.s,t.s,r),o=w.lerp(e.l,t.l,r);return this.setHSL(i,a,o),this}}(),equals:function(e){return e.r===this.r&&e.g===this.g&&e.b===this.b},fromArray:function(e,t){return t===void 0&&(t=0),this.r=e[t],this.g=e[t+1],this.b=e[t+2],this},toArray:function(e,t){return e===void 0&&(e=[]),t===void 0&&(t=0),e[t]=this.r,e[t+1]=this.g,e[t+2]=this.b,e},toJSON:function(){return this.getHex()}});function H(e,t,n,r,i,a){this.a=e,this.b=t,this.c=n,this.normal=r&&r.isVector3?r:new O,this.vertexNormals=Array.isArray(r)?r:[],this.color=i&&i.isColor?i:new V,this.vertexColors=Array.isArray(i)?i:[],this.materialIndex=a===void 0?0:a}Object.assign(H.prototype,{clone:function(){return new this.constructor().copy(this)},copy:function(e){this.a=e.a,this.b=e.b,this.c=e.c,this.normal.copy(e.normal),this.color.copy(e.color),this.materialIndex=e.materialIndex;for(var t=0,n=e.vertexNormals.length;t<n;t++)this.vertexNormals[t]=e.vertexNormals[t].clone();for(var t=0,n=e.vertexColors.length;t<n;t++)this.vertexColors[t]=e.vertexColors[t].clone();return this}});var U=0;function W(){Object.defineProperty(this,"id",{value:U++}),this.uuid=w.generateUUID(),this.name=``,this.type=`Material`,this.fog=!0,this.lights=!0,this.blending=1,this.side=0,this.flatShading=!1,this.vertexColors=0,this.opacity=1,this.transparent=!1,this.blendSrc=204,this.blendDst=205,this.blendEquation=100,this.blendSrcAlpha=null,this.blendDstAlpha=null,this.blendEquationAlpha=null,this.depthFunc=3,this.depthTest=!0,this.depthWrite=!0,this.clippingPlanes=null,this.clipIntersection=!1,this.clipShadows=!1,this.shadowSide=null,this.colorWrite=!0,this.precision=null,this.polygonOffset=!1,this.polygonOffsetFactor=0,this.polygonOffsetUnits=0,this.dithering=!1,this.alphaTest=0,this.premultipliedAlpha=!1,this.visible=!0,this.userData={},this.needsUpdate=!0}W.prototype=Object.assign(Object.create(n.prototype),{constructor:W,isMaterial:!0,onBeforeCompile:function(){},setValues:function(e){if(e!==void 0)for(var t in e){var n=e[t];if(n===void 0){console.warn(`THREE.Material: '`+t+`' parameter is undefined.`);continue}if(t===`shading`){console.warn(`THREE.`+this.type+`: .shading has been removed. Use the boolean .flatShading instead.`),this.flatShading=n===1;continue}var r=this[t];if(r===void 0){console.warn(`THREE.`+this.type+`: '`+t+`' is not a property of this material.`);continue}r&&r.isColor?r.set(n):r&&r.isVector3&&n&&n.isVector3?r.copy(n):this[t]=n}},toJSON:function(e){var t=e===void 0||typeof e==`string`;t&&(e={textures:{},images:{}});var n={metadata:{version:4.5,type:`Material`,generator:`Material.toJSON`}};n.uuid=this.uuid,n.type=this.type,this.name!==``&&(n.name=this.name),this.color&&this.color.isColor&&(n.color=this.color.getHex()),this.roughness!==void 0&&(n.roughness=this.roughness),this.metalness!==void 0&&(n.metalness=this.metalness),this.emissive&&this.emissive.isColor&&(n.emissive=this.emissive.getHex()),this.emissiveIntensity!==1&&(n.emissiveIntensity=this.emissiveIntensity),this.specular&&this.specular.isColor&&(n.specular=this.specular.getHex()),this.shininess!==void 0&&(n.shininess=this.shininess),this.clearCoat!==void 0&&(n.clearCoat=this.clearCoat),this.clearCoatRoughness!==void 0&&(n.clearCoatRoughness=this.clearCoatRoughness),this.map&&this.map.isTexture&&(n.map=this.map.toJSON(e).uuid),this.alphaMap&&this.alphaMap.isTexture&&(n.alphaMap=this.alphaMap.toJSON(e).uuid),this.lightMap&&this.lightMap.isTexture&&(n.lightMap=this.lightMap.toJSON(e).uuid),this.aoMap&&this.aoMap.isTexture&&(n.aoMap=this.aoMap.toJSON(e).uuid,n.aoMapIntensity=this.aoMapIntensity),this.bumpMap&&this.bumpMap.isTexture&&(n.bumpMap=this.bumpMap.toJSON(e).uuid,n.bumpScale=this.bumpScale),this.normalMap&&this.normalMap.isTexture&&(n.normalMap=this.normalMap.toJSON(e).uuid,n.normalMapType=this.normalMapType,n.normalScale=this.normalScale.toArray()),this.displacementMap&&this.displacementMap.isTexture&&(n.displacementMap=this.displacementMap.toJSON(e).uuid,n.displacementScale=this.displacementScale,n.displacementBias=this.displacementBias),this.roughnessMap&&this.roughnessMap.isTexture&&(n.roughnessMap=this.roughnessMap.toJSON(e).uuid),this.metalnessMap&&this.metalnessMap.isTexture&&(n.metalnessMap=this.metalnessMap.toJSON(e).uuid),this.emissiveMap&&this.emissiveMap.isTexture&&(n.emissiveMap=this.emissiveMap.toJSON(e).uuid),this.specularMap&&this.specularMap.isTexture&&(n.specularMap=this.specularMap.toJSON(e).uuid),this.envMap&&this.envMap.isTexture&&(n.envMap=this.envMap.toJSON(e).uuid,n.reflectivity=this.reflectivity,this.combine!==void 0&&(n.combine=this.combine),this.envMapIntensity!==void 0&&(n.envMapIntensity=this.envMapIntensity)),this.gradientMap&&this.gradientMap.isTexture&&(n.gradientMap=this.gradientMap.toJSON(e).uuid),this.size!==void 0&&(n.size=this.size),this.sizeAttenuation!==void 0&&(n.sizeAttenuation=this.sizeAttenuation),this.blending!==1&&(n.blending=this.blending),this.flatShading===!0&&(n.flatShading=this.flatShading),this.side!==0&&(n.side=this.side),this.vertexColors!==0&&(n.vertexColors=this.vertexColors),this.opacity<1&&(n.opacity=this.opacity),this.transparent===!0&&(n.transparent=this.transparent),n.depthFunc=this.depthFunc,n.depthTest=this.depthTest,n.depthWrite=this.depthWrite,this.rotation!==0&&(n.rotation=this.rotation),this.polygonOffset===!0&&(n.polygonOffset=!0),this.polygonOffsetFactor!==0&&(n.polygonOffsetFactor=this.polygonOffsetFactor),this.polygonOffsetUnits!==0&&(n.polygonOffsetUnits=this.polygonOffsetUnits),this.linewidth!==1&&(n.linewidth=this.linewidth),this.dashSize!==void 0&&(n.dashSize=this.dashSize),this.gapSize!==void 0&&(n.gapSize=this.gapSize),this.scale!==void 0&&(n.scale=this.scale),this.dithering===!0&&(n.dithering=!0),this.alphaTest>0&&(n.alphaTest=this.alphaTest),this.premultipliedAlpha===!0&&(n.premultipliedAlpha=this.premultipliedAlpha),this.wireframe===!0&&(n.wireframe=this.wireframe),this.wireframeLinewidth>1&&(n.wireframeLinewidth=this.wireframeLinewidth),this.wireframeLinecap!==`round`&&(n.wireframeLinecap=this.wireframeLinecap),this.wireframeLinejoin!==`round`&&(n.wireframeLinejoin=this.wireframeLinejoin),this.morphTargets===!0&&(n.morphTargets=!0),this.skinning===!0&&(n.skinning=!0),this.visible===!1&&(n.visible=!1),JSON.stringify(this.userData)!==`{}`&&(n.userData=this.userData);function r(e){var t=[];for(var n in e){var r=e[n];delete r.metadata,t.push(r)}return t}if(t){var i=r(e.textures),a=r(e.images);i.length>0&&(n.textures=i),a.length>0&&(n.images=a)}return n},clone:function(){return new this.constructor().copy(this)},copy:function(e){this.name=e.name,this.fog=e.fog,this.lights=e.lights,this.blending=e.blending,this.side=e.side,this.flatShading=e.flatShading,this.vertexColors=e.vertexColors,this.opacity=e.opacity,this.transparent=e.transparent,this.blendSrc=e.blendSrc,this.blendDst=e.blendDst,this.blendEquation=e.blendEquation,this.blendSrcAlpha=e.blendSrcAlpha,this.blendDstAlpha=e.blendDstAlpha,this.blendEquationAlpha=e.blendEquationAlpha,this.depthFunc=e.depthFunc,this.depthTest=e.depthTest,this.depthWrite=e.depthWrite,this.colorWrite=e.colorWrite,this.precision=e.precision,this.polygonOffset=e.polygonOffset,this.polygonOffsetFactor=e.polygonOffsetFactor,this.polygonOffsetUnits=e.polygonOffsetUnits,this.dithering=e.dithering,this.alphaTest=e.alphaTest,this.premultipliedAlpha=e.premultipliedAlpha,this.visible=e.visible,this.userData=JSON.parse(JSON.stringify(e.userData)),this.clipShadows=e.clipShadows,this.clipIntersection=e.clipIntersection;var t=e.clippingPlanes,n=null;if(t!==null){var r=t.length;n=Array(r);for(var i=0;i!==r;++i)n[i]=t[i].clone()}return this.clippingPlanes=n,this.shadowSide=e.shadowSide,this},dispose:function(){this.dispatchEvent({type:`dispose`})}});function G(e){W.call(this),this.type=`MeshBasicMaterial`,this.color=new V(16777215),this.map=null,this.lightMap=null,this.lightMapIntensity=1,this.aoMap=null,this.aoMapIntensity=1,this.specularMap=null,this.alphaMap=null,this.envMap=null,this.combine=0,this.reflectivity=1,this.refractionRatio=.98,this.wireframe=!1,this.wireframeLinewidth=1,this.wireframeLinecap=`round`,this.wireframeLinejoin=`round`,this.skinning=!1,this.morphTargets=!1,this.lights=!1,this.setValues(e)}G.prototype=Object.create(W.prototype),G.prototype.constructor=G,G.prototype.isMeshBasicMaterial=!0,G.prototype.copy=function(e){return W.prototype.copy.call(this,e),this.color.copy(e.color),this.map=e.map,this.lightMap=e.lightMap,this.lightMapIntensity=e.lightMapIntensity,this.aoMap=e.aoMap,this.aoMapIntensity=e.aoMapIntensity,this.specularMap=e.specularMap,this.alphaMap=e.alphaMap,this.envMap=e.envMap,this.combine=e.combine,this.reflectivity=e.reflectivity,this.refractionRatio=e.refractionRatio,this.wireframe=e.wireframe,this.wireframeLinewidth=e.wireframeLinewidth,this.wireframeLinecap=e.wireframeLinecap,this.wireframeLinejoin=e.wireframeLinejoin,this.skinning=e.skinning,this.morphTargets=e.morphTargets,this};function K(e,t,n,r){this.x=e||0,this.y=t||0,this.z=n||0,this.w=r===void 0?1:r}Object.assign(K.prototype,{isVector4:!0,set:function(e,t,n,r){return this.x=e,this.y=t,this.z=n,this.w=r,this},setScalar:function(e){return this.x=e,this.y=e,this.z=e,this.w=e,this},setX:function(e){return this.x=e,this},setY:function(e){return this.y=e,this},setZ:function(e){return this.z=e,this},setW:function(e){return this.w=e,this},setComponent:function(e,t){switch(e){case 0:this.x=t;break;case 1:this.y=t;break;case 2:this.z=t;break;case 3:this.w=t;break;default:throw Error(`index is out of range: `+e)}return this},getComponent:function(e){switch(e){case 0:return this.x;case 1:return this.y;case 2:return this.z;case 3:return this.w;default:throw Error(`index is out of range: `+e)}},clone:function(){return new this.constructor(this.x,this.y,this.z,this.w)},copy:function(e){return this.x=e.x,this.y=e.y,this.z=e.z,this.w=e.w===void 0?1:e.w,this},add:function(e,t){return t===void 0?(this.x+=e.x,this.y+=e.y,this.z+=e.z,this.w+=e.w,this):(console.warn(`THREE.Vector4: .add() now only accepts one argument. Use .addVectors( a, b ) instead.`),this.addVectors(e,t))},addScalar:function(e){return this.x+=e,this.y+=e,this.z+=e,this.w+=e,this},addVectors:function(e,t){return this.x=e.x+t.x,this.y=e.y+t.y,this.z=e.z+t.z,this.w=e.w+t.w,this},addScaledVector:function(e,t){return this.x+=e.x*t,this.y+=e.y*t,this.z+=e.z*t,this.w+=e.w*t,this},sub:function(e,t){return t===void 0?(this.x-=e.x,this.y-=e.y,this.z-=e.z,this.w-=e.w,this):(console.warn(`THREE.Vector4: .sub() now only accepts one argument. Use .subVectors( a, b ) instead.`),this.subVectors(e,t))},subScalar:function(e){return this.x-=e,this.y-=e,this.z-=e,this.w-=e,this},subVectors:function(e,t){return this.x=e.x-t.x,this.y=e.y-t.y,this.z=e.z-t.z,this.w=e.w-t.w,this},multiplyScalar:function(e){return this.x*=e,this.y*=e,this.z*=e,this.w*=e,this},applyMatrix4:function(e){var t=this.x,n=this.y,r=this.z,i=this.w,a=e.elements;return this.x=a[0]*t+a[4]*n+a[8]*r+a[12]*i,this.y=a[1]*t+a[5]*n+a[9]*r+a[13]*i,this.z=a[2]*t+a[6]*n+a[10]*r+a[14]*i,this.w=a[3]*t+a[7]*n+a[11]*r+a[15]*i,this},divideScalar:function(e){return this.multiplyScalar(1/e)},setAxisAngleFromQuaternion:function(e){this.w=2*Math.acos(e.w);var t=Math.sqrt(1-e.w*e.w);return t<1e-4?(this.x=1,this.y=0,this.z=0):(this.x=e.x/t,this.y=e.y/t,this.z=e.z/t),this},setAxisAngleFromRotationMatrix:function(e){var t,n,r,i,a=.01,o=.1,s=e.elements,c=s[0],l=s[4],u=s[8],d=s[1],f=s[5],p=s[9],m=s[2],h=s[6],g=s[10];if(Math.abs(l-d)<a&&Math.abs(u-m)<a&&Math.abs(p-h)<a){if(Math.abs(l+d)<o&&Math.abs(u+m)<o&&Math.abs(p+h)<o&&Math.abs(c+f+g-3)<o)return this.set(1,0,0,0),this;t=Math.PI;var _=(c+1)/2,v=(f+1)/2,y=(g+1)/2,b=(l+d)/4,x=(u+m)/4,S=(p+h)/4;return _>v&&_>y?_<a?(n=0,r=.707106781,i=.707106781):(n=Math.sqrt(_),r=b/n,i=x/n):v>y?v<a?(n=.707106781,r=0,i=.707106781):(r=Math.sqrt(v),n=b/r,i=S/r):y<a?(n=.707106781,r=.707106781,i=0):(i=Math.sqrt(y),n=x/i,r=S/i),this.set(n,r,i,t),this}var C=Math.sqrt((h-p)*(h-p)+(u-m)*(u-m)+(d-l)*(d-l));return Math.abs(C)<.001&&(C=1),this.x=(h-p)/C,this.y=(u-m)/C,this.z=(d-l)/C,this.w=Math.acos((c+f+g-1)/2),this},min:function(e){return this.x=Math.min(this.x,e.x),this.y=Math.min(this.y,e.y),this.z=Math.min(this.z,e.z),this.w=Math.min(this.w,e.w),this},max:function(e){return this.x=Math.max(this.x,e.x),this.y=Math.max(this.y,e.y),this.z=Math.max(this.z,e.z),this.w=Math.max(this.w,e.w),this},clamp:function(e,t){return this.x=Math.max(e.x,Math.min(t.x,this.x)),this.y=Math.max(e.y,Math.min(t.y,this.y)),this.z=Math.max(e.z,Math.min(t.z,this.z)),this.w=Math.max(e.w,Math.min(t.w,this.w)),this},clampScalar:function(){var e,t;return function(n,r){return e===void 0&&(e=new K,t=new K),e.set(n,n,n,n),t.set(r,r,r,r),this.clamp(e,t)}}(),clampLength:function(e,t){var n=this.length();return this.divideScalar(n||1).multiplyScalar(Math.max(e,Math.min(t,n)))},floor:function(){return this.x=Math.floor(this.x),this.y=Math.floor(this.y),this.z=Math.floor(this.z),this.w=Math.floor(this.w),this},ceil:function(){return this.x=Math.ceil(this.x),this.y=Math.ceil(this.y),this.z=Math.ceil(this.z),this.w=Math.ceil(this.w),this},round:function(){return this.x=Math.round(this.x),this.y=Math.round(this.y),this.z=Math.round(this.z),this.w=Math.round(this.w),this},roundToZero:function(){return this.x=this.x<0?Math.ceil(this.x):Math.floor(this.x),this.y=this.y<0?Math.ceil(this.y):Math.floor(this.y),this.z=this.z<0?Math.ceil(this.z):Math.floor(this.z),this.w=this.w<0?Math.ceil(this.w):Math.floor(this.w),this},negate:function(){return this.x=-this.x,this.y=-this.y,this.z=-this.z,this.w=-this.w,this},dot:function(e){return this.x*e.x+this.y*e.y+this.z*e.z+this.w*e.w},lengthSq:function(){return this.x*this.x+this.y*this.y+this.z*this.z+this.w*this.w},length:function(){return Math.sqrt(this.x*this.x+this.y*this.y+this.z*this.z+this.w*this.w)},manhattanLength:function(){return Math.abs(this.x)+Math.abs(this.y)+Math.abs(this.z)+Math.abs(this.w)},normalize:function(){return this.divideScalar(this.length()||1)},setLength:function(e){return this.normalize().multiplyScalar(e)},lerp:function(e,t){return this.x+=(e.x-this.x)*t,this.y+=(e.y-this.y)*t,this.z+=(e.z-this.z)*t,this.w+=(e.w-this.w)*t,this},lerpVectors:function(e,t,n){return this.subVectors(t,e).multiplyScalar(n).add(e)},equals:function(e){return e.x===this.x&&e.y===this.y&&e.z===this.z&&e.w===this.w},fromArray:function(e,t){return t===void 0&&(t=0),this.x=e[t],this.y=e[t+1],this.z=e[t+2],this.w=e[t+3],this},toArray:function(e,t){return e===void 0&&(e=[]),t===void 0&&(t=0),e[t]=this.x,e[t+1]=this.y,e[t+2]=this.z,e[t+3]=this.w,e},fromBufferAttribute:function(e,t,n){return n!==void 0&&console.warn(`THREE.Vector4: offset has been removed from .fromBufferAttribute().`),this.x=e.getX(t),this.y=e.getY(t),this.z=e.getZ(t),this.w=e.getW(t),this}});function q(e,t,n){if(Array.isArray(e))throw TypeError(`THREE.BufferAttribute: array should be a Typed Array.`);this.name=``,this.array=e,this.itemSize=t,this.count=e===void 0?0:e.length/t,this.normalized=n===!0,this.dynamic=!1,this.updateRange={offset:0,count:-1},this.version=0}Object.defineProperty(q.prototype,"needsUpdate",{set:function(e){e===!0&&this.version++}}),Object.assign(q.prototype,{isBufferAttribute:!0,onUploadCallback:function(){},setArray:function(e){if(Array.isArray(e))throw TypeError(`THREE.BufferAttribute: array should be a Typed Array.`);return this.count=e===void 0?0:e.length/this.itemSize,this.array=e,this},setDynamic:function(e){return this.dynamic=e,this},copy:function(e){return this.name=e.name,this.array=new e.array.constructor(e.array),this.itemSize=e.itemSize,this.count=e.count,this.normalized=e.normalized,this.dynamic=e.dynamic,this},copyAt:function(e,t,n){e*=this.itemSize,n*=t.itemSize;for(var r=0,i=this.itemSize;r<i;r++)this.array[e+r]=t.array[n+r];return this},copyArray:function(e){return this.array.set(e),this},copyColorsArray:function(e){for(var t=this.array,n=0,r=0,i=e.length;r<i;r++){var a=e[r];a===void 0&&(console.warn(`THREE.BufferAttribute.copyColorsArray(): color is undefined`,r),a=new V),t[n++]=a.r,t[n++]=a.g,t[n++]=a.b}return this},copyVector2sArray:function(e){for(var t=this.array,n=0,r=0,i=e.length;r<i;r++){var a=e[r];a===void 0&&(console.warn(`THREE.BufferAttribute.copyVector2sArray(): vector is undefined`,r),a=new T),t[n++]=a.x,t[n++]=a.y}return this},copyVector3sArray:function(e){for(var t=this.array,n=0,r=0,i=e.length;r<i;r++){var a=e[r];a===void 0&&(console.warn(`THREE.BufferAttribute.copyVector3sArray(): vector is undefined`,r),a=new O),t[n++]=a.x,t[n++]=a.y,t[n++]=a.z}return this},copyVector4sArray:function(e){for(var t=this.array,n=0,r=0,i=e.length;r<i;r++){var a=e[r];a===void 0&&(console.warn(`THREE.BufferAttribute.copyVector4sArray(): vector is undefined`,r),a=new K),t[n++]=a.x,t[n++]=a.y,t[n++]=a.z,t[n++]=a.w}return this},set:function(e,t){return t===void 0&&(t=0),this.array.set(e,t),this},getX:function(e){return this.array[e*this.itemSize]},setX:function(e,t){return this.array[e*this.itemSize]=t,this},getY:function(e){return this.array[e*this.itemSize+1]},setY:function(e,t){return this.array[e*this.itemSize+1]=t,this},getZ:function(e){return this.array[e*this.itemSize+2]},setZ:function(e,t){return this.array[e*this.itemSize+2]=t,this},getW:function(e){return this.array[e*this.itemSize+3]},setW:function(e,t){return this.array[e*this.itemSize+3]=t,this},setXY:function(e,t,n){return e*=this.itemSize,this.array[e+0]=t,this.array[e+1]=n,this},setXYZ:function(e,t,n,r){return e*=this.itemSize,this.array[e+0]=t,this.array[e+1]=n,this.array[e+2]=r,this},setXYZW:function(e,t,n,r,i){return e*=this.itemSize,this.array[e+0]=t,this.array[e+1]=n,this.array[e+2]=r,this.array[e+3]=i,this},onUpload:function(e){return this.onUploadCallback=e,this},clone:function(){return new this.constructor(this.array,this.itemSize).copy(this)}});function re(e,t,n){q.call(this,new Int8Array(e),t,n)}re.prototype=Object.create(q.prototype),re.prototype.constructor=re;function ie(e,t,n){q.call(this,new Uint8Array(e),t,n)}ie.prototype=Object.create(q.prototype),ie.prototype.constructor=ie;function ae(e,t,n){q.call(this,new Uint8ClampedArray(e),t,n)}ae.prototype=Object.create(q.prototype),ae.prototype.constructor=ae;function oe(e,t,n){q.call(this,new Int16Array(e),t,n)}oe.prototype=Object.create(q.prototype),oe.prototype.constructor=oe;function J(e,t,n){q.call(this,new Uint16Array(e),t,n)}J.prototype=Object.create(q.prototype),J.prototype.constructor=J;function se(e,t,n){q.call(this,new Int32Array(e),t,n)}se.prototype=Object.create(q.prototype),se.prototype.constructor=se;function ce(e,t,n){q.call(this,new Uint32Array(e),t,n)}ce.prototype=Object.create(q.prototype),ce.prototype.constructor=ce;function Y(e,t,n){q.call(this,new Float32Array(e),t,n)}Y.prototype=Object.create(q.prototype),Y.prototype.constructor=Y;function le(e,t,n){q.call(this,new Float64Array(e),t,n)}le.prototype=Object.create(q.prototype),le.prototype.constructor=le;function ue(){this.vertices=[],this.normals=[],this.colors=[],this.uvs=[],this.uvs2=[],this.groups=[],this.morphTargets={},this.skinWeights=[],this.skinIndices=[],this.boundingBox=null,this.boundingSphere=null,this.verticesNeedUpdate=!1,this.normalsNeedUpdate=!1,this.colorsNeedUpdate=!1,this.uvsNeedUpdate=!1,this.groupsNeedUpdate=!1}Object.assign(ue.prototype,{computeGroups:function(e){for(var t,n=[],r=void 0,i=e.faces,a=0;a<i.length;a++){var o=i[a];o.materialIndex!==r&&(r=o.materialIndex,t!==void 0&&(t.count=a*3-t.start,n.push(t)),t={start:a*3,materialIndex:r})}t!==void 0&&(t.count=a*3-t.start,n.push(t)),this.groups=n},fromGeometry:function(e){var t=e.faces,n=e.vertices,r=e.faceVertexUvs,i=r[0]&&r[0].length>0,a=r[1]&&r[1].length>0,o=e.morphTargets,s=o.length,c;if(s>0){c=[];for(var l=0;l<s;l++)c[l]={name:o[l].name,data:[]};this.morphTargets.position=c}var u=e.morphNormals,d=u.length,f;if(d>0){f=[];for(var l=0;l<d;l++)f[l]={name:u[l].name,data:[]};this.morphTargets.normal=f}var p=e.skinIndices,m=e.skinWeights,h=p.length===n.length,g=m.length===n.length;n.length>0&&t.length===0&&console.error(`THREE.DirectGeometry: Faceless geometries are not supported.`);for(var l=0;l<t.length;l++){var _=t[l];this.vertices.push(n[_.a],n[_.b],n[_.c]);var v=_.vertexNormals;if(v.length===3)this.normals.push(v[0],v[1],v[2]);else{var y=_.normal;this.normals.push(y,y,y)}var b=_.vertexColors;if(b.length===3)this.colors.push(b[0],b[1],b[2]);else{var x=_.color;this.colors.push(x,x,x)}if(i===!0){var S=r[0][l];S===void 0?(console.warn(`THREE.DirectGeometry.fromGeometry(): Undefined vertexUv `,l),this.uvs.push(new T,new T,new T)):this.uvs.push(S[0],S[1],S[2])}if(a===!0){var S=r[1][l];S===void 0?(console.warn(`THREE.DirectGeometry.fromGeometry(): Undefined vertexUv2 `,l),this.uvs2.push(new T,new T,new T)):this.uvs2.push(S[0],S[1],S[2])}for(var C=0;C<s;C++){var w=o[C].vertices;c[C].data.push(w[_.a],w[_.b],w[_.c])}for(var C=0;C<d;C++){var E=u[C].vertexNormals[l];f[C].data.push(E.a,E.b,E.c)}h&&this.skinIndices.push(p[_.a],p[_.b],p[_.c]),g&&this.skinWeights.push(m[_.a],m[_.b],m[_.c])}return this.computeGroups(e),this.verticesNeedUpdate=e.verticesNeedUpdate,this.normalsNeedUpdate=e.normalsNeedUpdate,this.colorsNeedUpdate=e.colorsNeedUpdate,this.uvsNeedUpdate=e.uvsNeedUpdate,this.groupsNeedUpdate=e.groupsNeedUpdate,this}});function de(e){if(e.length===0)return-1/0;for(var t=e[0],n=1,r=e.length;n<r;++n)e[n]>t&&(t=e[n]);return t}var fe=1;function pe(){Object.defineProperty(this,"id",{value:fe+=2}),this.uuid=w.generateUUID(),this.name=``,this.type=`BufferGeometry`,this.index=null,this.attributes={},this.morphAttributes={},this.groups=[],this.boundingBox=null,this.boundingSphere=null,this.drawRange={start:0,count:1/0},this.userData={}}pe.prototype=Object.assign(Object.create(n.prototype),{constructor:pe,isBufferGeometry:!0,getIndex:function(){return this.index},setIndex:function(e){Array.isArray(e)?this.index=new(de(e)>65535?ce:J)(e,1):this.index=e},addAttribute:function(e,t){return!(t&&t.isBufferAttribute)&&!(t&&t.isInterleavedBufferAttribute)?(console.warn(`THREE.BufferGeometry: .addAttribute() now expects ( name, attribute ).`),this.addAttribute(e,new q(arguments[1],arguments[2]))):e===`index`?(console.warn(`THREE.BufferGeometry.addAttribute: Use .setIndex() for index attribute.`),this.setIndex(t),this):(this.attributes[e]=t,this)},getAttribute:function(e){return this.attributes[e]},removeAttribute:function(e){return delete this.attributes[e],this},addGroup:function(e,t,n){this.groups.push({start:e,count:t,materialIndex:n===void 0?0:n})},clearGroups:function(){this.groups=[]},setDrawRange:function(e,t){this.drawRange.start=e,this.drawRange.count=t},applyMatrix:function(e){var t=this.attributes.position;t!==void 0&&(e.applyToBufferAttribute(t),t.needsUpdate=!0);var n=this.attributes.normal;return n!==void 0&&(new k().getNormalMatrix(e).applyToBufferAttribute(n),n.needsUpdate=!0),this.boundingBox!==null&&this.computeBoundingBox(),this.boundingSphere!==null&&this.computeBoundingSphere(),this},rotateX:function(){var e=new E;return function(t){return e.makeRotationX(t),this.applyMatrix(e),this}}(),rotateY:function(){var e=new E;return function(t){return e.makeRotationY(t),this.applyMatrix(e),this}}(),rotateZ:function(){var e=new E;return function(t){return e.makeRotationZ(t),this.applyMatrix(e),this}}(),translate:function(){var e=new E;return function(t,n,r){return e.makeTranslation(t,n,r),this.applyMatrix(e),this}}(),scale:function(){var e=new E;return function(t,n,r){return e.makeScale(t,n,r),this.applyMatrix(e),this}}(),lookAt:function(){var e=new z;return function(t){e.lookAt(t),e.updateMatrix(),this.applyMatrix(e.matrix)}}(),center:function(){var e=new O;return function(){return this.computeBoundingBox(),this.boundingBox.getCenter(e).negate(),this.translate(e.x,e.y,e.z),this}}(),setFromObject:function(e){var t=e.geometry;if(e.isPoints||e.isLine){var n=new Y(t.vertices.length*3,3),r=new Y(t.colors.length*3,3);if(this.addAttribute(`position`,n.copyVector3sArray(t.vertices)),this.addAttribute(`color`,r.copyColorsArray(t.colors)),t.lineDistances&&t.lineDistances.length===t.vertices.length){var i=new Y(t.lineDistances.length,1);this.addAttribute(`lineDistance`,i.copyArray(t.lineDistances))}t.boundingSphere!==null&&(this.boundingSphere=t.boundingSphere.clone()),t.boundingBox!==null&&(this.boundingBox=t.boundingBox.clone())}else e.isMesh&&t&&t.isGeometry&&this.fromGeometry(t);return this},setFromPoints:function(e){for(var t=[],n=0,r=e.length;n<r;n++){var i=e[n];t.push(i.x,i.y,i.z||0)}return this.addAttribute(`position`,new Y(t,3)),this},updateFromObject:function(e){var t=e.geometry;if(e.isMesh){var n=t.__directGeometry;if(t.elementsNeedUpdate===!0&&(n=void 0,t.elementsNeedUpdate=!1),n===void 0)return this.fromGeometry(t);n.verticesNeedUpdate=t.verticesNeedUpdate,n.normalsNeedUpdate=t.normalsNeedUpdate,n.colorsNeedUpdate=t.colorsNeedUpdate,n.uvsNeedUpdate=t.uvsNeedUpdate,n.groupsNeedUpdate=t.groupsNeedUpdate,t.verticesNeedUpdate=!1,t.normalsNeedUpdate=!1,t.colorsNeedUpdate=!1,t.uvsNeedUpdate=!1,t.groupsNeedUpdate=!1,t=n}var r;return t.verticesNeedUpdate===!0&&(r=this.attributes.position,r!==void 0&&(r.copyVector3sArray(t.vertices),r.needsUpdate=!0),t.verticesNeedUpdate=!1),t.normalsNeedUpdate===!0&&(r=this.attributes.normal,r!==void 0&&(r.copyVector3sArray(t.normals),r.needsUpdate=!0),t.normalsNeedUpdate=!1),t.colorsNeedUpdate===!0&&(r=this.attributes.color,r!==void 0&&(r.copyColorsArray(t.colors),r.needsUpdate=!0),t.colorsNeedUpdate=!1),t.uvsNeedUpdate&&(r=this.attributes.uv,r!==void 0&&(r.copyVector2sArray(t.uvs),r.needsUpdate=!0),t.uvsNeedUpdate=!1),t.lineDistancesNeedUpdate&&(r=this.attributes.lineDistance,r!==void 0&&(r.copyArray(t.lineDistances),r.needsUpdate=!0),t.lineDistancesNeedUpdate=!1),t.groupsNeedUpdate&&(t.computeGroups(e.geometry),this.groups=t.groups,t.groupsNeedUpdate=!1),this},fromGeometry:function(e){return e.__directGeometry=new ue().fromGeometry(e),this.fromDirectGeometry(e.__directGeometry)},fromDirectGeometry:function(e){var t=new Float32Array(e.vertices.length*3);if(this.addAttribute(`position`,new q(t,3).copyVector3sArray(e.vertices)),e.normals.length>0){var n=new Float32Array(e.normals.length*3);this.addAttribute(`normal`,new q(n,3).copyVector3sArray(e.normals))}if(e.colors.length>0){var r=new Float32Array(e.colors.length*3);this.addAttribute(`color`,new q(r,3).copyColorsArray(e.colors))}if(e.uvs.length>0){var i=new Float32Array(e.uvs.length*2);this.addAttribute(`uv`,new q(i,2).copyVector2sArray(e.uvs))}if(e.uvs2.length>0){var a=new Float32Array(e.uvs2.length*2);this.addAttribute(`uv2`,new q(a,2).copyVector2sArray(e.uvs2))}for(var o in this.groups=e.groups,e.morphTargets){for(var s=[],c=e.morphTargets[o],l=0,u=c.length;l<u;l++){var d=c[l],f=new Y(d.data.length*3,3);f.name=d.name,s.push(f.copyVector3sArray(d.data))}this.morphAttributes[o]=s}if(e.skinIndices.length>0){var p=new Y(e.skinIndices.length*4,4);this.addAttribute(`skinIndex`,p.copyVector4sArray(e.skinIndices))}if(e.skinWeights.length>0){var m=new Y(e.skinWeights.length*4,4);this.addAttribute(`skinWeight`,m.copyVector4sArray(e.skinWeights))}return e.boundingSphere!==null&&(this.boundingSphere=e.boundingSphere.clone()),e.boundingBox!==null&&(this.boundingBox=e.boundingBox.clone()),this},computeBoundingBox:function(){this.boundingBox===null&&(this.boundingBox=new F);var e=this.attributes.position;e===void 0?this.boundingBox.makeEmpty():this.boundingBox.setFromBufferAttribute(e),(isNaN(this.boundingBox.min.x)||isNaN(this.boundingBox.min.y)||isNaN(this.boundingBox.min.z))&&console.error(`THREE.BufferGeometry.computeBoundingBox: Computed min/max have NaN values. The "position" attribute is likely to have NaN values.`,this)},computeBoundingSphere:function(){var e=new F,t=new O;return function(){this.boundingSphere===null&&(this.boundingSphere=new I);var n=this.attributes.position;if(n){var r=this.boundingSphere.center;e.setFromBufferAttribute(n),e.getCenter(r);for(var i=0,a=0,o=n.count;a<o;a++)t.x=n.getX(a),t.y=n.getY(a),t.z=n.getZ(a),i=Math.max(i,r.distanceToSquared(t));this.boundingSphere.radius=Math.sqrt(i),isNaN(this.boundingSphere.radius)&&console.error(`THREE.BufferGeometry.computeBoundingSphere(): Computed radius is NaN. The "position" attribute is likely to have NaN values.`,this)}}}(),computeFaceNormals:function(){},computeVertexNormals:function(){var e=this.index,t=this.attributes;if(t.position){var n=t.position.array;if(t.normal===void 0)this.addAttribute(`normal`,new q(new Float32Array(n.length),3));else for(var r=t.normal.array,i=0,a=r.length;i<a;i++)r[i]=0;var o=t.normal.array,s,c,l,u=new O,d=new O,f=new O,p=new O,m=new O;if(e)for(var h=e.array,i=0,a=e.count;i<a;i+=3)s=h[i+0]*3,c=h[i+1]*3,l=h[i+2]*3,u.fromArray(n,s),d.fromArray(n,c),f.fromArray(n,l),p.subVectors(f,d),m.subVectors(u,d),p.cross(m),o[s]+=p.x,o[s+1]+=p.y,o[s+2]+=p.z,o[c]+=p.x,o[c+1]+=p.y,o[c+2]+=p.z,o[l]+=p.x,o[l+1]+=p.y,o[l+2]+=p.z;else for(var i=0,a=n.length;i<a;i+=9)u.fromArray(n,i),d.fromArray(n,i+3),f.fromArray(n,i+6),p.subVectors(f,d),m.subVectors(u,d),p.cross(m),o[i]=p.x,o[i+1]=p.y,o[i+2]=p.z,o[i+3]=p.x,o[i+4]=p.y,o[i+5]=p.z,o[i+6]=p.x,o[i+7]=p.y,o[i+8]=p.z;this.normalizeNormals(),t.normal.needsUpdate=!0}},merge:function(e,t){if(!(e&&e.isBufferGeometry)){console.error(`THREE.BufferGeometry.merge(): geometry not an instance of THREE.BufferGeometry.`,e);return}t===void 0&&(t=0,console.warn(`THREE.BufferGeometry.merge(): Overwriting original geometry, starting at offset=0. Use BufferGeometryUtils.mergeBufferGeometries() for lossless merge.`));var n=this.attributes;for(var r in n)if(e.attributes[r]!==void 0)for(var i=n[r].array,a=e.attributes[r],o=a.array,s=a.itemSize,c=0,l=s*t;c<o.length;c++,l++)i[l]=o[c];return this},normalizeNormals:function(){var e=new O;return function(){for(var t=this.attributes.normal,n=0,r=t.count;n<r;n++)e.x=t.getX(n),e.y=t.getY(n),e.z=t.getZ(n),e.normalize(),t.setXYZ(n,e.x,e.y,e.z)}}(),toNonIndexed:function(){function e(e,t){for(var n=e.array,r=e.itemSize,i=new n.constructor(t.length*r),a=0,o=0,s=0,c=t.length;s<c;s++){a=t[s]*r;for(var l=0;l<r;l++)i[o++]=n[a++]}return new q(i,r)}if(this.index===null)return console.warn(`THREE.BufferGeometry.toNonIndexed(): Geometry is already non-indexed.`),this;var t=new pe,n=this.index.array,r=this.attributes;for(var i in r){var a=r[i],o=e(a,n);t.addAttribute(i,o)}var s=this.morphAttributes;for(i in s){for(var c=[],l=s[i],u=0,d=l.length;u<d;u++){var a=l[u],o=e(a,n);c.push(o)}t.morphAttributes[i]=c}for(var f=this.groups,u=0,p=f.length;u<p;u++){var m=f[u];t.addGroup(m.start,m.count,m.materialIndex)}return t},toJSON:function(){var e={metadata:{version:4.5,type:`BufferGeometry`,generator:`BufferGeometry.toJSON`}};if(e.uuid=this.uuid,e.type=this.type,this.name!==``&&(e.name=this.name),Object.keys(this.userData).length>0&&(e.userData=this.userData),this.parameters!==void 0){var t=this.parameters;for(var n in t)t[n]!==void 0&&(e[n]=t[n]);return e}e.data={attributes:{}};var r=this.index;if(r!==null){var i=Array.prototype.slice.call(r.array);e.data.index={type:r.array.constructor.name,array:i}}var a=this.attributes;for(var n in a){var o=a[n],i=Array.prototype.slice.call(o.array);e.data.attributes[n]={itemSize:o.itemSize,type:o.array.constructor.name,array:i,normalized:o.normalized}}var s=this.groups;s.length>0&&(e.data.groups=JSON.parse(JSON.stringify(s)));var c=this.boundingSphere;return c!==null&&(e.data.boundingSphere={center:c.center.toArray(),radius:c.radius}),e},clone:function(){return new pe().copy(this)},copy:function(e){var t,n,r;this.index=null,this.attributes={},this.morphAttributes={},this.groups=[],this.boundingBox=null,this.boundingSphere=null,this.name=e.name;var i=e.index;i!==null&&this.setIndex(i.clone());var a=e.attributes;for(t in a){var o=a[t];this.addAttribute(t,o.clone())}var s=e.morphAttributes;for(t in s){var c=[],l=s[t];for(n=0,r=l.length;n<r;n++)c.push(l[n].clone());this.morphAttributes[t]=c}var u=e.groups;for(n=0,r=u.length;n<r;n++){var d=u[n];this.addGroup(d.start,d.count,d.materialIndex)}var f=e.boundingBox;f!==null&&(this.boundingBox=f.clone());var p=e.boundingSphere;return p!==null&&(this.boundingSphere=p.clone()),this.drawRange.start=e.drawRange.start,this.drawRange.count=e.drawRange.count,this.userData=e.userData,this},dispose:function(){this.dispatchEvent({type:`dispose`})}});function me(e,t){z.call(this),this.type=`Mesh`,this.geometry=e===void 0?new pe:e,this.material=t===void 0?new G({color:Math.random()*16777215}):t,this.drawMode=0,this.updateMorphTargets()}me.prototype=Object.assign(Object.create(z.prototype),{constructor:me,isMesh:!0,setDrawMode:function(e){this.drawMode=e},copy:function(e){return z.prototype.copy.call(this,e),this.drawMode=e.drawMode,e.morphTargetInfluences!==void 0&&(this.morphTargetInfluences=e.morphTargetInfluences.slice()),e.morphTargetDictionary!==void 0&&(this.morphTargetDictionary=Object.assign({},e.morphTargetDictionary)),this},updateMorphTargets:function(){var e=this.geometry,t,n,r;if(e.isBufferGeometry){var i=e.morphAttributes,a=Object.keys(i);if(a.length>0){var o=i[a[0]];if(o!==void 0)for(this.morphTargetInfluences=[],this.morphTargetDictionary={},t=0,n=o.length;t<n;t++)r=o[t].name||String(t),this.morphTargetInfluences.push(0),this.morphTargetDictionary[r]=t}}else{var s=e.morphTargets;s!==void 0&&s.length>0&&console.error(`THREE.Mesh.updateMorphTargets() no longer supports THREE.Geometry. Use THREE.BufferGeometry instead.`)}},raycast:function(){var e=new E,t=new L,n=new I,r=new O,i=new O,a=new O,o=new O,s=new O,c=new O,l=new T,u=new T,d=new T,f=new O,p=new O;function m(e,t,n,r,i,a,o,s){if((t.side===1?r.intersectTriangle(o,a,i,!0,s):r.intersectTriangle(i,a,o,t.side!==2,s))===null)return null;p.copy(s),p.applyMatrix4(e.matrixWorld);var c=n.ray.origin.distanceTo(p);return c<n.near||c>n.far?null:{distance:c,point:p.clone(),object:e}}function h(e,t,n,o,s,c,p,h,g){r.fromBufferAttribute(s,p),i.fromBufferAttribute(s,h),a.fromBufferAttribute(s,g);var _=m(e,t,n,o,r,i,a,f);if(_){c&&(l.fromBufferAttribute(c,p),u.fromBufferAttribute(c,h),d.fromBufferAttribute(c,g),_.uv=ne.getUV(f,r,i,a,l,u,d,new T));var v=new H(p,h,g);ne.getNormal(r,i,a,v.normal),_.face=v}return _}return function(p,g){var _=this.geometry,v=this.material,y=this.matrixWorld;if(v!==void 0&&(_.boundingSphere===null&&_.computeBoundingSphere(),n.copy(_.boundingSphere),n.applyMatrix4(y),p.ray.intersectsSphere(n)!==!1&&(e.getInverse(y),t.copy(p.ray).applyMatrix4(e),!(_.boundingBox!==null&&t.intersectsBox(_.boundingBox)===!1)))){var b;if(_.isBufferGeometry){var x,S,C,w=_.index,E=_.attributes.position,D=_.attributes.uv,O=_.groups,k=_.drawRange,A,j,M,N,P,F,I,L;if(w!==null)if(Array.isArray(v))for(A=0,M=O.length;A<M;A++)for(P=O[A],F=v[P.materialIndex],I=Math.max(P.start,k.start),L=Math.min(P.start+P.count,k.start+k.count),j=I,N=L;j<N;j+=3)x=w.getX(j),S=w.getX(j+1),C=w.getX(j+2),b=h(this,F,p,t,E,D,x,S,C),b&&(b.faceIndex=Math.floor(j/3),g.push(b));else for(I=Math.max(0,k.start),L=Math.min(w.count,k.start+k.count),A=I,M=L;A<M;A+=3)x=w.getX(A),S=w.getX(A+1),C=w.getX(A+2),b=h(this,v,p,t,E,D,x,S,C),b&&(b.faceIndex=Math.floor(A/3),g.push(b));else if(E!==void 0)if(Array.isArray(v))for(A=0,M=O.length;A<M;A++)for(P=O[A],F=v[P.materialIndex],I=Math.max(P.start,k.start),L=Math.min(P.start+P.count,k.start+k.count),j=I,N=L;j<N;j+=3)x=j,S=j+1,C=j+2,b=h(this,F,p,t,E,D,x,S,C),b&&(b.faceIndex=Math.floor(j/3),g.push(b));else for(I=Math.max(0,k.start),L=Math.min(E.count,k.start+k.count),A=I,M=L;A<M;A+=3)x=A,S=A+1,C=A+2,b=h(this,v,p,t,E,D,x,S,C),b&&(b.faceIndex=Math.floor(A/3),g.push(b))}else if(_.isGeometry){var R,ee,te,z=Array.isArray(v),B=_.vertices,V=_.faces,H,U=_.faceVertexUvs[0];U.length>0&&(H=U);for(var W=0,G=V.length;W<G;W++){var K=V[W],q=z?v[K.materialIndex]:v;if(q!==void 0){if(R=B[K.a],ee=B[K.b],te=B[K.c],q.morphTargets===!0){var re=_.morphTargets,ie=this.morphTargetInfluences;r.set(0,0,0),i.set(0,0,0),a.set(0,0,0);for(var ae=0,oe=re.length;ae<oe;ae++){var J=ie[ae];if(J!==0){var se=re[ae].vertices;r.addScaledVector(o.subVectors(se[K.a],R),J),i.addScaledVector(s.subVectors(se[K.b],ee),J),a.addScaledVector(c.subVectors(se[K.c],te),J)}}r.add(R),i.add(ee),a.add(te),R=r,ee=i,te=a}if(b=m(this,q,p,t,R,ee,te,f),b){if(H&&H[W]){var ce=H[W];l.copy(ce[0]),u.copy(ce[1]),d.copy(ce[2]),b.uv=ne.getUV(f,R,ee,te,l,u,d,new T)}b.face=K,b.faceIndex=W,g.push(b)}}}}}}}(),clone:function(){return new this.constructor(this.geometry,this.material).copy(this)}});function he(){z.call(this),this.type=`Camera`,this.matrixWorldInverse=new E,this.projectionMatrix=new E,this.projectionMatrixInverse=new E}he.prototype=Object.assign(Object.create(z.prototype),{constructor:he,isCamera:!0,copy:function(e,t){return z.prototype.copy.call(this,e,t),this.matrixWorldInverse.copy(e.matrixWorldInverse),this.projectionMatrix.copy(e.projectionMatrix),this.projectionMatrixInverse.copy(e.projectionMatrixInverse),this},getWorldDirection:function(e){e===void 0&&(console.warn(`THREE.Camera: .getWorldDirection() target is now required`),e=new O),this.updateMatrixWorld(!0);var t=this.matrixWorld.elements;return e.set(-t[8],-t[9],-t[10]).normalize()},updateMatrixWorld:function(e){z.prototype.updateMatrixWorld.call(this,e),this.matrixWorldInverse.getInverse(this.matrixWorld)},clone:function(){return new this.constructor().copy(this)}});function ge(e,t,n,r,i,a){he.call(this),this.type=`OrthographicCamera`,this.zoom=1,this.view=null,this.left=e===void 0?-1:e,this.right=t===void 0?1:t,this.top=n===void 0?1:n,this.bottom=r===void 0?-1:r,this.near=i===void 0?.1:i,this.far=a===void 0?2e3:a,this.updateProjectionMatrix()}ge.prototype=Object.assign(Object.create(he.prototype),{constructor:ge,isOrthographicCamera:!0,copy:function(e,t){return he.prototype.copy.call(this,e,t),this.left=e.left,this.right=e.right,this.top=e.top,this.bottom=e.bottom,this.near=e.near,this.far=e.far,this.zoom=e.zoom,this.view=e.view===null?null:Object.assign({},e.view),this},setViewOffset:function(e,t,n,r,i,a){this.view===null&&(this.view={enabled:!0,fullWidth:1,fullHeight:1,offsetX:0,offsetY:0,width:1,height:1}),this.view.enabled=!0,this.view.fullWidth=e,this.view.fullHeight=t,this.view.offsetX=n,this.view.offsetY=r,this.view.width=i,this.view.height=a,this.updateProjectionMatrix()},clearViewOffset:function(){this.view!==null&&(this.view.enabled=!1),this.updateProjectionMatrix()},updateProjectionMatrix:function(){var e=(this.right-this.left)/(2*this.zoom),t=(this.top-this.bottom)/(2*this.zoom),n=(this.right+this.left)/2,r=(this.top+this.bottom)/2,i=n-e,a=n+e,o=r+t,s=r-t;if(this.view!==null&&this.view.enabled){var c=this.zoom/(this.view.width/this.view.fullWidth),l=this.zoom/(this.view.height/this.view.fullHeight),u=(this.right-this.left)/this.view.width,d=(this.top-this.bottom)/this.view.height;i+=u*(this.view.offsetX/c),a=i+u*(this.view.width/c),o-=d*(this.view.offsetY/l),s=o-d*(this.view.height/l)}this.projectionMatrix.makeOrthographic(i,a,o,s,this.near,this.far),this.projectionMatrixInverse.getInverse(this.projectionMatrix)},toJSON:function(e){var t=z.prototype.toJSON.call(this,e);return t.object.zoom=this.zoom,t.object.left=this.left,t.object.right=this.right,t.object.top=this.top,t.object.bottom=this.bottom,t.object.near=this.near,t.object.far=this.far,this.view!==null&&(t.object.view=Object.assign({},this.view)),t}});var _e=0;function ve(){Object.defineProperty(this,"id",{value:_e+=2}),this.uuid=w.generateUUID(),this.name=``,this.type=`Geometry`,this.vertices=[],this.colors=[],this.faces=[],this.faceVertexUvs=[[]],this.morphTargets=[],this.morphNormals=[],this.skinWeights=[],this.skinIndices=[],this.lineDistances=[],this.boundingBox=null,this.boundingSphere=null,this.elementsNeedUpdate=!1,this.verticesNeedUpdate=!1,this.uvsNeedUpdate=!1,this.normalsNeedUpdate=!1,this.colorsNeedUpdate=!1,this.lineDistancesNeedUpdate=!1,this.groupsNeedUpdate=!1}ve.prototype=Object.assign(Object.create(n.prototype),{constructor:ve,isGeometry:!0,applyMatrix:function(e){for(var t=new k().getNormalMatrix(e),n=0,r=this.vertices.length;n<r;n++)this.vertices[n].applyMatrix4(e);for(var n=0,r=this.faces.length;n<r;n++){var i=this.faces[n];i.normal.applyMatrix3(t).normalize();for(var a=0,o=i.vertexNormals.length;a<o;a++)i.vertexNormals[a].applyMatrix3(t).normalize()}return this.boundingBox!==null&&this.computeBoundingBox(),this.boundingSphere!==null&&this.computeBoundingSphere(),this.verticesNeedUpdate=!0,this.normalsNeedUpdate=!0,this},rotateX:function(){var e=new E;return function(t){return e.makeRotationX(t),this.applyMatrix(e),this}}(),rotateY:function(){var e=new E;return function(t){return e.makeRotationY(t),this.applyMatrix(e),this}}(),rotateZ:function(){var e=new E;return function(t){return e.makeRotationZ(t),this.applyMatrix(e),this}}(),translate:function(){var e=new E;return function(t,n,r){return e.makeTranslation(t,n,r),this.applyMatrix(e),this}}(),scale:function(){var e=new E;return function(t,n,r){return e.makeScale(t,n,r),this.applyMatrix(e),this}}(),lookAt:function(){var e=new z;return function(t){e.lookAt(t),e.updateMatrix(),this.applyMatrix(e.matrix)}}(),fromBufferGeometry:function(e){var t=this,n=e.index===null?void 0:e.index.array,r=e.attributes,i=r.position.array,a=r.normal===void 0?void 0:r.normal.array,o=r.color===void 0?void 0:r.color.array,s=r.uv===void 0?void 0:r.uv.array,c=r.uv2===void 0?void 0:r.uv2.array;c!==void 0&&(this.faceVertexUvs[1]=[]);for(var l=0,u=0;l<i.length;l+=3,u+=2)t.vertices.push(new O().fromArray(i,l)),o!==void 0&&t.colors.push(new V().fromArray(o,l));function d(e,n,r,i){var l=o===void 0?[]:[t.colors[e].clone(),t.colors[n].clone(),t.colors[r].clone()],u=new H(e,n,r,a===void 0?[]:[new O().fromArray(a,e*3),new O().fromArray(a,n*3),new O().fromArray(a,r*3)],l,i);t.faces.push(u),s!==void 0&&t.faceVertexUvs[0].push([new T().fromArray(s,e*2),new T().fromArray(s,n*2),new T().fromArray(s,r*2)]),c!==void 0&&t.faceVertexUvs[1].push([new T().fromArray(c,e*2),new T().fromArray(c,n*2),new T().fromArray(c,r*2)])}var f=e.groups;if(f.length>0)for(var l=0;l<f.length;l++)for(var p=f[l],m=p.start,h=p.count,u=m,g=m+h;u<g;u+=3)n===void 0?d(u,u+1,u+2,p.materialIndex):d(n[u],n[u+1],n[u+2],p.materialIndex);else if(n!==void 0)for(var l=0;l<n.length;l+=3)d(n[l],n[l+1],n[l+2]);else for(var l=0;l<i.length/3;l+=3)d(l,l+1,l+2);return this.computeFaceNormals(),e.boundingBox!==null&&(this.boundingBox=e.boundingBox.clone()),e.boundingSphere!==null&&(this.boundingSphere=e.boundingSphere.clone()),this},center:function(){var e=new O;return function(){return this.computeBoundingBox(),this.boundingBox.getCenter(e).negate(),this.translate(e.x,e.y,e.z),this}}(),normalize:function(){this.computeBoundingSphere();var e=this.boundingSphere.center,t=this.boundingSphere.radius,n=t===0?1:1/t,r=new E;return r.set(n,0,0,-n*e.x,0,n,0,-n*e.y,0,0,n,-n*e.z,0,0,0,1),this.applyMatrix(r),this},computeFaceNormals:function(){for(var e=new O,t=new O,n=0,r=this.faces.length;n<r;n++){var i=this.faces[n],a=this.vertices[i.a],o=this.vertices[i.b],s=this.vertices[i.c];e.subVectors(s,o),t.subVectors(a,o),e.cross(t),e.normalize(),i.normal.copy(e)}},computeVertexNormals:function(e){e===void 0&&(e=!0);var t,n,r,i,a,o=Array(this.vertices.length);for(t=0,n=this.vertices.length;t<n;t++)o[t]=new O;if(e){var s,c,l,u=new O,d=new O;for(r=0,i=this.faces.length;r<i;r++)a=this.faces[r],s=this.vertices[a.a],c=this.vertices[a.b],l=this.vertices[a.c],u.subVectors(l,c),d.subVectors(s,c),u.cross(d),o[a.a].add(u),o[a.b].add(u),o[a.c].add(u)}else for(this.computeFaceNormals(),r=0,i=this.faces.length;r<i;r++)a=this.faces[r],o[a.a].add(a.normal),o[a.b].add(a.normal),o[a.c].add(a.normal);for(t=0,n=this.vertices.length;t<n;t++)o[t].normalize();for(r=0,i=this.faces.length;r<i;r++){a=this.faces[r];var f=a.vertexNormals;f.length===3?(f[0].copy(o[a.a]),f[1].copy(o[a.b]),f[2].copy(o[a.c])):(f[0]=o[a.a].clone(),f[1]=o[a.b].clone(),f[2]=o[a.c].clone())}this.faces.length>0&&(this.normalsNeedUpdate=!0)},computeFlatVertexNormals:function(){var e,t,n;for(this.computeFaceNormals(),e=0,t=this.faces.length;e<t;e++){n=this.faces[e];var r=n.vertexNormals;r.length===3?(r[0].copy(n.normal),r[1].copy(n.normal),r[2].copy(n.normal)):(r[0]=n.normal.clone(),r[1]=n.normal.clone(),r[2]=n.normal.clone())}this.faces.length>0&&(this.normalsNeedUpdate=!0)},computeMorphNormals:function(){var e,t,n,r,i;for(n=0,r=this.faces.length;n<r;n++)for(i=this.faces[n],i.__originalFaceNormal?i.__originalFaceNormal.copy(i.normal):i.__originalFaceNormal=i.normal.clone(),i.__originalVertexNormals||=[],e=0,t=i.vertexNormals.length;e<t;e++)i.__originalVertexNormals[e]?i.__originalVertexNormals[e].copy(i.vertexNormals[e]):i.__originalVertexNormals[e]=i.vertexNormals[e].clone();var a=new ve;for(a.faces=this.faces,e=0,t=this.morphTargets.length;e<t;e++){if(!this.morphNormals[e]){this.morphNormals[e]={},this.morphNormals[e].faceNormals=[],this.morphNormals[e].vertexNormals=[];var o=this.morphNormals[e].faceNormals,s=this.morphNormals[e].vertexNormals,c,l;for(n=0,r=this.faces.length;n<r;n++)c=new O,l={a:new O,b:new O,c:new O},o.push(c),s.push(l)}var u=this.morphNormals[e];a.vertices=this.morphTargets[e].vertices,a.computeFaceNormals(),a.computeVertexNormals();var c,l;for(n=0,r=this.faces.length;n<r;n++)i=this.faces[n],c=u.faceNormals[n],l=u.vertexNormals[n],c.copy(i.normal),l.a.copy(i.vertexNormals[0]),l.b.copy(i.vertexNormals[1]),l.c.copy(i.vertexNormals[2])}for(n=0,r=this.faces.length;n<r;n++)i=this.faces[n],i.normal=i.__originalFaceNormal,i.vertexNormals=i.__originalVertexNormals},computeBoundingBox:function(){this.boundingBox===null&&(this.boundingBox=new F),this.boundingBox.setFromPoints(this.vertices)},computeBoundingSphere:function(){this.boundingSphere===null&&(this.boundingSphere=new I),this.boundingSphere.setFromPoints(this.vertices)},merge:function(e,t,n){if(!(e&&e.isGeometry)){console.error(`THREE.Geometry.merge(): geometry not an instance of THREE.Geometry.`,e);return}var r,i=this.vertices.length,a=this.vertices,o=e.vertices,s=this.faces,c=e.faces,l=this.faceVertexUvs[0],u=e.faceVertexUvs[0],d=this.colors,f=e.colors;n===void 0&&(n=0),t!==void 0&&(r=new k().getNormalMatrix(t));for(var p=0,m=o.length;p<m;p++){var h=o[p].clone();t!==void 0&&h.applyMatrix4(t),a.push(h)}for(var p=0,m=f.length;p<m;p++)d.push(f[p].clone());for(p=0,m=c.length;p<m;p++){var g=c[p],_,v,y,b=g.vertexNormals,x=g.vertexColors;_=new H(g.a+i,g.b+i,g.c+i),_.normal.copy(g.normal),r!==void 0&&_.normal.applyMatrix3(r).normalize();for(var S=0,C=b.length;S<C;S++)v=b[S].clone(),r!==void 0&&v.applyMatrix3(r).normalize(),_.vertexNormals.push(v);_.color.copy(g.color);for(var S=0,C=x.length;S<C;S++)y=x[S],_.vertexColors.push(y.clone());_.materialIndex=g.materialIndex+n,s.push(_)}for(p=0,m=u.length;p<m;p++){var w=u[p],T=[];if(w!==void 0){for(var S=0,C=w.length;S<C;S++)T.push(w[S].clone());l.push(T)}}},mergeMesh:function(e){if(!(e&&e.isMesh)){console.error(`THREE.Geometry.mergeMesh(): mesh not an instance of THREE.Mesh.`,e);return}e.matrixAutoUpdate&&e.updateMatrix(),this.merge(e.geometry,e.matrix)},mergeVertices:function(){var e={},t=[],n=[],r,i,a=10**4,o,s,c,l,u,d;for(o=0,s=this.vertices.length;o<s;o++)r=this.vertices[o],i=Math.round(r.x*a)+`_`+Math.round(r.y*a)+`_`+Math.round(r.z*a),e[i]===void 0?(e[i]=o,t.push(this.vertices[o]),n[o]=t.length-1):n[o]=n[e[i]];var f=[];for(o=0,s=this.faces.length;o<s;o++){c=this.faces[o],c.a=n[c.a],c.b=n[c.b],c.c=n[c.c],l=[c.a,c.b,c.c];for(var p=0;p<3;p++)if(l[p]===l[(p+1)%3]){f.push(o);break}}for(o=f.length-1;o>=0;o--){var m=f[o];for(this.faces.splice(m,1),u=0,d=this.faceVertexUvs.length;u<d;u++)this.faceVertexUvs[u].splice(m,1)}var h=this.vertices.length-t.length;return this.vertices=t,h},setFromPoints:function(e){this.vertices=[];for(var t=0,n=e.length;t<n;t++){var r=e[t];this.vertices.push(new O(r.x,r.y,r.z||0))}return this},sortFacesByMaterialIndex:function(){for(var e=this.faces,t=e.length,n=0;n<t;n++)e[n]._id=n;function r(e,t){return e.materialIndex-t.materialIndex}e.sort(r);var i=this.faceVertexUvs[0],a=this.faceVertexUvs[1],o,s;i&&i.length===t&&(o=[]),a&&a.length===t&&(s=[]);for(var n=0;n<t;n++){var c=e[n]._id;o&&o.push(i[c]),s&&s.push(a[c])}o&&(this.faceVertexUvs[0]=o),s&&(this.faceVertexUvs[1]=s)},toJSON:function(){var e={metadata:{version:4.5,type:`Geometry`,generator:`Geometry.toJSON`}};if(e.uuid=this.uuid,e.type=this.type,this.name!==``&&(e.name=this.name),this.parameters!==void 0){var t=this.parameters;for(var n in t)t[n]!==void 0&&(e[n]=t[n]);return e}for(var r=[],i=0;i<this.vertices.length;i++){var a=this.vertices[i];r.push(a.x,a.y,a.z)}for(var o=[],s=[],c={},l=[],u={},d=[],f={},i=0;i<this.faces.length;i++){var p=this.faces[i],m=!0,h=!1,g=this.faceVertexUvs[0][i]!==void 0,_=p.normal.length()>0,v=p.vertexNormals.length>0,y=p.color.r!==1||p.color.g!==1||p.color.b!==1,b=p.vertexColors.length>0,x=0;if(x=T(x,0,0),x=T(x,1,m),x=T(x,2,h),x=T(x,3,g),x=T(x,4,_),x=T(x,5,v),x=T(x,6,y),x=T(x,7,b),o.push(x),o.push(p.a,p.b,p.c),o.push(p.materialIndex),g){var S=this.faceVertexUvs[0][i];o.push(O(S[0]),O(S[1]),O(S[2]))}if(_&&o.push(E(p.normal)),v){var C=p.vertexNormals;o.push(E(C[0]),E(C[1]),E(C[2]))}if(y&&o.push(D(p.color)),b){var w=p.vertexColors;o.push(D(w[0]),D(w[1]),D(w[2]))}}function T(e,t,n){return n?e|1<<t:e&~(1<<t)}function E(e){var t=e.x.toString()+e.y.toString()+e.z.toString();return c[t]===void 0?(c[t]=s.length/3,s.push(e.x,e.y,e.z),c[t]):c[t]}function D(e){var t=e.r.toString()+e.g.toString()+e.b.toString();return u[t]===void 0?(u[t]=l.length,l.push(e.getHex()),u[t]):u[t]}function O(e){var t=e.x.toString()+e.y.toString();return f[t]===void 0?(f[t]=d.length/2,d.push(e.x,e.y),f[t]):f[t]}return e.data={},e.data.vertices=r,e.data.normals=s,l.length>0&&(e.data.colors=l),d.length>0&&(e.data.uvs=[d]),e.data.faces=o,e},clone:function(){return new ve().copy(this)},copy:function(e){var t,n,r,i,a,o;this.vertices=[],this.colors=[],this.faces=[],this.faceVertexUvs=[[]],this.morphTargets=[],this.morphNormals=[],this.skinWeights=[],this.skinIndices=[],this.lineDistances=[],this.boundingBox=null,this.boundingSphere=null,this.name=e.name;var s=e.vertices;for(t=0,n=s.length;t<n;t++)this.vertices.push(s[t].clone());var c=e.colors;for(t=0,n=c.length;t<n;t++)this.colors.push(c[t].clone());var l=e.faces;for(t=0,n=l.length;t<n;t++)this.faces.push(l[t].clone());for(t=0,n=e.faceVertexUvs.length;t<n;t++){var u=e.faceVertexUvs[t];for(this.faceVertexUvs[t]===void 0&&(this.faceVertexUvs[t]=[]),r=0,i=u.length;r<i;r++){var d=u[r],f=[];for(a=0,o=d.length;a<o;a++){var p=d[a];f.push(p.clone())}this.faceVertexUvs[t].push(f)}}var m=e.morphTargets;for(t=0,n=m.length;t<n;t++){var h={};if(h.name=m[t].name,m[t].vertices!==void 0)for(h.vertices=[],r=0,i=m[t].vertices.length;r<i;r++)h.vertices.push(m[t].vertices[r].clone());if(m[t].normals!==void 0)for(h.normals=[],r=0,i=m[t].normals.length;r<i;r++)h.normals.push(m[t].normals[r].clone());this.morphTargets.push(h)}var g=e.morphNormals;for(t=0,n=g.length;t<n;t++){var _={};if(g[t].vertexNormals!==void 0)for(_.vertexNormals=[],r=0,i=g[t].vertexNormals.length;r<i;r++){var v=g[t].vertexNormals[r],y={};y.a=v.a.clone(),y.b=v.b.clone(),y.c=v.c.clone(),_.vertexNormals.push(y)}if(g[t].faceNormals!==void 0)for(_.faceNormals=[],r=0,i=g[t].faceNormals.length;r<i;r++)_.faceNormals.push(g[t].faceNormals[r].clone());this.morphNormals.push(_)}var b=e.skinWeights;for(t=0,n=b.length;t<n;t++)this.skinWeights.push(b[t].clone());var x=e.skinIndices;for(t=0,n=x.length;t<n;t++)this.skinIndices.push(x[t].clone());var S=e.lineDistances;for(t=0,n=S.length;t<n;t++)this.lineDistances.push(S[t]);var C=e.boundingBox;C!==null&&(this.boundingBox=C.clone());var w=e.boundingSphere;return w!==null&&(this.boundingSphere=w.clone()),this.elementsNeedUpdate=e.elementsNeedUpdate,this.verticesNeedUpdate=e.verticesNeedUpdate,this.uvsNeedUpdate=e.uvsNeedUpdate,this.normalsNeedUpdate=e.normalsNeedUpdate,this.colorsNeedUpdate=e.colorsNeedUpdate,this.lineDistancesNeedUpdate=e.lineDistancesNeedUpdate,this.groupsNeedUpdate=e.groupsNeedUpdate,this},dispose:function(){this.dispatchEvent({type:`dispose`})}});function ye(e,t,n,r){ve.call(this),this.type=`PlaneGeometry`,this.parameters={width:e,height:t,widthSegments:n,heightSegments:r},this.fromBufferGeometry(new be(e,t,n,r)),this.mergeVertices()}ye.prototype=Object.create(ve.prototype),ye.prototype.constructor=ye;function be(e,t,n,r){pe.call(this),this.type=`PlaneBufferGeometry`,this.parameters={width:e,height:t,widthSegments:n,heightSegments:r},e||=1,t||=1;var i=e/2,a=t/2,o=Math.floor(n)||1,s=Math.floor(r)||1,c=o+1,l=s+1,u=e/o,d=t/s,f,p,m=[],h=[],g=[],_=[];for(p=0;p<l;p++){var v=p*d-a;for(f=0;f<c;f++){var y=f*u-i;h.push(y,-v,0),g.push(0,0,1),_.push(f/o),_.push(1-p/s)}}for(p=0;p<s;p++)for(f=0;f<o;f++){var b=f+c*p,x=f+c*(p+1),S=f+1+c*(p+1),C=f+1+c*p;m.push(b,x,C),m.push(x,S,C)}this.setIndex(m),this.addAttribute(`position`,new Y(h,3)),this.addAttribute(`normal`,new Y(g,3)),this.addAttribute(`uv`,new Y(_,2))}be.prototype=Object.create(pe.prototype),be.prototype.constructor=be;function xe(){z.call(this),this.type=`Scene`,this.background=null,this.fog=null,this.overrideMaterial=null,this.autoUpdate=!0}xe.prototype=Object.assign(Object.create(z.prototype),{constructor:xe,copy:function(e,t){return z.prototype.copy.call(this,e,t),e.background!==null&&(this.background=e.background.clone()),e.fog!==null&&(this.fog=e.fog.clone()),e.overrideMaterial!==null&&(this.overrideMaterial=e.overrideMaterial.clone()),this.autoUpdate=e.autoUpdate,this.matrixAutoUpdate=e.matrixAutoUpdate,this},toJSON:function(e){var t=z.prototype.toJSON.call(this,e);return this.background!==null&&(t.object.background=this.background.toJSON(e)),this.fog!==null&&(t.object.fog=this.fog.toJSON()),t},dispose:function(){this.dispatchEvent({type:`dispose`})}});function Se(e){var t={};for(var n in e)for(var r in t[n]={},e[n]){var i=e[n][r];i&&(i.isColor||i.isMatrix3||i.isMatrix4||i.isVector2||i.isVector3||i.isVector4||i.isTexture)?t[n][r]=i.clone():Array.isArray(i)?t[n][r]=i.slice():t[n][r]=i}return t}function Ce(e){for(var t={},n=0;n<e.length;n++){var r=Se(e[n]);for(var i in r)t[i]=r[i]}return t}function we(e){W.call(this),this.type=`ShaderMaterial`,this.defines={},this.uniforms={},this.vertexShader=`void main() {
	gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );
}`,this.fragmentShader=`void main() {
	gl_FragColor = vec4( 1.0, 0.0, 0.0, 1.0 );
}`,this.linewidth=1,this.wireframe=!1,this.wireframeLinewidth=1,this.fog=!1,this.lights=!1,this.clipping=!1,this.skinning=!1,this.morphTargets=!1,this.morphNormals=!1,this.extensions={derivatives:!1,fragDepth:!1,drawBuffers:!1,shaderTextureLOD:!1},this.defaultAttributeValues={color:[1,1,1],uv:[0,0],uv2:[0,0]},this.index0AttributeName=void 0,this.uniformsNeedUpdate=!1,e!==void 0&&(e.attributes!==void 0&&console.error(`THREE.ShaderMaterial: attributes should now be defined in THREE.BufferGeometry instead.`),this.setValues(e))}we.prototype=Object.create(W.prototype),we.prototype.constructor=we,we.prototype.isShaderMaterial=!0,we.prototype.copy=function(e){return W.prototype.copy.call(this,e),this.fragmentShader=e.fragmentShader,this.vertexShader=e.vertexShader,this.uniforms=Se(e.uniforms),this.defines=Object.assign({},e.defines),this.wireframe=e.wireframe,this.wireframeLinewidth=e.wireframeLinewidth,this.lights=e.lights,this.clipping=e.clipping,this.skinning=e.skinning,this.morphTargets=e.morphTargets,this.morphNormals=e.morphNormals,this.extensions=e.extensions,this},we.prototype.toJSON=function(e){var t=W.prototype.toJSON.call(this,e);for(var n in t.uniforms={},this.uniforms){var r=this.uniforms[n].value;r&&r.isTexture?t.uniforms[n]={type:`t`,value:r.toJSON(e).uuid}:r&&r.isColor?t.uniforms[n]={type:`c`,value:r.getHex()}:r&&r.isVector2?t.uniforms[n]={type:`v2`,value:r.toArray()}:r&&r.isVector3?t.uniforms[n]={type:`v3`,value:r.toArray()}:r&&r.isVector4?t.uniforms[n]={type:`v4`,value:r.toArray()}:r&&r.isMatrix3?t.uniforms[n]={type:`m3`,value:r.toArray()}:r&&r.isMatrix4?t.uniforms[n]={type:`m4`,value:r.toArray()}:t.uniforms[n]={value:r}}Object.keys(this.defines).length>0&&(t.defines=this.defines),t.vertexShader=this.vertexShader,t.fragmentShader=this.fragmentShader;var i={};for(var a in this.extensions)this.extensions[a]===!0&&(i[a]=!0);return Object.keys(i).length>0&&(t.extensions=i),t};function Te(e,t,n){this.width=e,this.height=t,this.scissor=new K(0,0,e,t),this.scissorTest=!1,this.viewport=new K(0,0,e,t),n||={},this.texture=new N(void 0,void 0,n.wrapS,n.wrapT,n.magFilter,n.minFilter,n.format,n.type,n.anisotropy,n.encoding),this.texture.generateMipmaps=n.generateMipmaps!==void 0&&n.generateMipmaps,this.texture.minFilter=n.minFilter===void 0?s:n.minFilter,this.depthBuffer=n.depthBuffer===void 0||n.depthBuffer,this.stencilBuffer=n.stencilBuffer===void 0||n.stencilBuffer,this.depthTexture=n.depthTexture===void 0?null:n.depthTexture}Te.prototype=Object.assign(Object.create(n.prototype),{constructor:Te,isWebGLRenderTarget:!0,setSize:function(e,t){(this.width!==e||this.height!==t)&&(this.width=e,this.height=t,this.dispose()),this.viewport.set(0,0,e,t),this.scissor.set(0,0,e,t)},clone:function(){return new this.constructor().copy(this)},copy:function(e){return this.width=e.width,this.height=e.height,this.viewport.copy(e.viewport),this.texture=e.texture.clone(),this.depthBuffer=e.depthBuffer,this.stencilBuffer=e.stencilBuffer,this.depthTexture=e.depthTexture,this},dispose:function(){this.dispatchEvent({type:`dispose`})}});function Ee(e,t,n,r,i,a,s,c,l,u,d,f){N.call(this,null,a,s,c,l,u,r,i,d,f),this.image={data:e,width:t,height:n},this.magFilter=l===void 0?o:l,this.minFilter=u===void 0?o:u,this.generateMipmaps=!1,this.flipY=!1,this.unpackAlignment=1}Ee.prototype=Object.create(N.prototype),Ee.prototype.constructor=Ee,Ee.prototype.isDataTexture=!0;function De(e,t){this.normal=e===void 0?new O(1,0,0):e,this.constant=t===void 0?0:t}Object.assign(De.prototype,{set:function(e,t){return this.normal.copy(e),this.constant=t,this},setComponents:function(e,t,n,r){return this.normal.set(e,t,n),this.constant=r,this},setFromNormalAndCoplanarPoint:function(e,t){return this.normal.copy(e),this.constant=-t.dot(this.normal),this},setFromCoplanarPoints:function(){var e=new O,t=new O;return function(n,r,i){var a=e.subVectors(i,r).cross(t.subVectors(n,r)).normalize();return this.setFromNormalAndCoplanarPoint(a,n),this}}(),clone:function(){return new this.constructor().copy(this)},copy:function(e){return this.normal.copy(e.normal),this.constant=e.constant,this},normalize:function(){var e=1/this.normal.length();return this.normal.multiplyScalar(e),this.constant*=e,this},negate:function(){return this.constant*=-1,this.normal.negate(),this},distanceToPoint:function(e){return this.normal.dot(e)+this.constant},distanceToSphere:function(e){return this.distanceToPoint(e.center)-e.radius},projectPoint:function(e,t){return t===void 0&&(console.warn(`THREE.Plane: .projectPoint() target is now required`),t=new O),t.copy(this.normal).multiplyScalar(-this.distanceToPoint(e)).add(e)},intersectLine:function(){var e=new O;return function(t,n){n===void 0&&(console.warn(`THREE.Plane: .intersectLine() target is now required`),n=new O);var r=t.delta(e),i=this.normal.dot(r);if(i===0)return this.distanceToPoint(t.start)===0?n.copy(t.start):void 0;var a=-(t.start.dot(this.normal)+this.constant)/i;if(!(a<0||a>1))return n.copy(r).multiplyScalar(a).add(t.start)}}(),intersectsLine:function(e){var t=this.distanceToPoint(e.start),n=this.distanceToPoint(e.end);return t<0&&n>0||n<0&&t>0},intersectsBox:function(e){return e.intersectsPlane(this)},intersectsSphere:function(e){return e.intersectsPlane(this)},coplanarPoint:function(e){return e===void 0&&(console.warn(`THREE.Plane: .coplanarPoint() target is now required`),e=new O),e.copy(this.normal).multiplyScalar(-this.constant)},applyMatrix4:function(){var e=new O,t=new k;return function(n,r){var i=r||t.getNormalMatrix(n),a=this.coplanarPoint(e).applyMatrix4(n),o=this.normal.applyMatrix3(i).normalize();return this.constant=-a.dot(o),this}}(),translate:function(e){return this.constant-=e.dot(this.normal),this},equals:function(e){return e.normal.equals(this.normal)&&e.constant===this.constant}});function Oe(e,t,n,r,i,a){this.planes=[e===void 0?new De:e,t===void 0?new De:t,n===void 0?new De:n,r===void 0?new De:r,i===void 0?new De:i,a===void 0?new De:a]}Object.assign(Oe.prototype,{set:function(e,t,n,r,i,a){var o=this.planes;return o[0].copy(e),o[1].copy(t),o[2].copy(n),o[3].copy(r),o[4].copy(i),o[5].copy(a),this},clone:function(){return new this.constructor().copy(this)},copy:function(e){for(var t=this.planes,n=0;n<6;n++)t[n].copy(e.planes[n]);return this},setFromMatrix:function(e){var t=this.planes,n=e.elements,r=n[0],i=n[1],a=n[2],o=n[3],s=n[4],c=n[5],l=n[6],u=n[7],d=n[8],f=n[9],p=n[10],m=n[11],h=n[12],g=n[13],_=n[14],v=n[15];return t[0].setComponents(o-r,u-s,m-d,v-h).normalize(),t[1].setComponents(o+r,u+s,m+d,v+h).normalize(),t[2].setComponents(o+i,u+c,m+f,v+g).normalize(),t[3].setComponents(o-i,u-c,m-f,v-g).normalize(),t[4].setComponents(o-a,u-l,m-p,v-_).normalize(),t[5].setComponents(o+a,u+l,m+p,v+_).normalize(),this},intersectsObject:function(){var e=new I;return function(t){var n=t.geometry;return n.boundingSphere===null&&n.computeBoundingSphere(),e.copy(n.boundingSphere).applyMatrix4(t.matrixWorld),this.intersectsSphere(e)}}(),intersectsSprite:function(){var e=new I;return function(t){return e.center.set(0,0,0),e.radius=.7071067811865476,e.applyMatrix4(t.matrixWorld),this.intersectsSphere(e)}}(),intersectsSphere:function(e){for(var t=this.planes,n=e.center,r=-e.radius,i=0;i<6;i++)if(t[i].distanceToPoint(n)<r)return!1;return!0},intersectsBox:function(){var e=new O;return function(t){for(var n=this.planes,r=0;r<6;r++){var i=n[r];if(e.x=i.normal.x>0?t.max.x:t.min.x,e.y=i.normal.y>0?t.max.y:t.min.y,e.z=i.normal.z>0?t.max.z:t.min.z,i.distanceToPoint(e)<0)return!1}return!0}}(),containsPoint:function(e){for(var t=this.planes,n=0;n<6;n++)if(t[n].distanceToPoint(e)<0)return!1;return!0}});var X={alphamap_fragment:`
#ifdef USE_ALPHAMAP

	diffuseColor.a *= texture2D( alphaMap, vUv ).g;

#endif
`,alphamap_pars_fragment:`
#ifdef USE_ALPHAMAP

	uniform sampler2D alphaMap;

#endif
`,alphatest_fragment:`
#ifdef ALPHATEST

	if ( diffuseColor.a < ALPHATEST ) discard;

#endif
`,aomap_fragment:`
#ifdef USE_AOMAP

	// reads channel R, compatible with a combined OcclusionRoughnessMetallic (RGB) texture
	float ambientOcclusion = ( texture2D( aoMap, vUv2 ).r - 1.0 ) * aoMapIntensity + 1.0;

	reflectedLight.indirectDiffuse *= ambientOcclusion;

	#if defined( USE_ENVMAP ) && defined( PHYSICAL )

		float dotNV = saturate( dot( geometry.normal, geometry.viewDir ) );

		reflectedLight.indirectSpecular *= computeSpecularOcclusion( dotNV, ambientOcclusion, material.specularRoughness );

	#endif

#endif
`,aomap_pars_fragment:`
#ifdef USE_AOMAP

	uniform sampler2D aoMap;
	uniform float aoMapIntensity;

#endif
`,begin_vertex:`
vec3 transformed = vec3( position );
`,beginnormal_vertex:`
vec3 objectNormal = vec3( normal );
`,bsdfs:`
float punctualLightIntensityToIrradianceFactor( const in float lightDistance, const in float cutoffDistance, const in float decayExponent ) {

#if defined ( PHYSICALLY_CORRECT_LIGHTS )

	// based upon Frostbite 3 Moving to Physically-based Rendering
	// page 32, equation 26: E[window1]
	// https://seblagarde.files.wordpress.com/2015/07/course_notes_moving_frostbite_to_pbr_v32.pdf
	// this is intended to be used on spot and point lights who are represented as luminous intensity
	// but who must be converted to luminous irradiance for surface lighting calculation
	float distanceFalloff = 1.0 / max( pow( lightDistance, decayExponent ), 0.01 );

	if( cutoffDistance > 0.0 ) {

		distanceFalloff *= pow2( saturate( 1.0 - pow4( lightDistance / cutoffDistance ) ) );

	}

	return distanceFalloff;

#else

	if( cutoffDistance > 0.0 && decayExponent > 0.0 ) {

		return pow( saturate( -lightDistance / cutoffDistance + 1.0 ), decayExponent );

	}

	return 1.0;

#endif

}

vec3 BRDF_Diffuse_Lambert( const in vec3 diffuseColor ) {

	return RECIPROCAL_PI * diffuseColor;

} // validated

vec3 F_Schlick( const in vec3 specularColor, const in float dotLH ) {

	// Original approximation by Christophe Schlick '94
	// float fresnel = pow( 1.0 - dotLH, 5.0 );

	// Optimized variant (presented by Epic at SIGGRAPH '13)
	// https://cdn2.unrealengine.com/Resources/files/2013SiggraphPresentationsNotes-26915738.pdf
	float fresnel = exp2( ( -5.55473 * dotLH - 6.98316 ) * dotLH );

	return ( 1.0 - specularColor ) * fresnel + specularColor;

} // validated

// Microfacet Models for Refraction through Rough Surfaces - equation (34)
// http://graphicrants.blogspot.com/2013/08/specular-brdf-reference.html
// alpha is "roughness squared" in Disney’s reparameterization
float G_GGX_Smith( const in float alpha, const in float dotNL, const in float dotNV ) {

	// geometry term (normalized) = G(l)⋅G(v) / 4(n⋅l)(n⋅v)
	// also see #12151

	float a2 = pow2( alpha );

	float gl = dotNL + sqrt( a2 + ( 1.0 - a2 ) * pow2( dotNL ) );
	float gv = dotNV + sqrt( a2 + ( 1.0 - a2 ) * pow2( dotNV ) );

	return 1.0 / ( gl * gv );

} // validated

// Moving Frostbite to Physically Based Rendering 3.0 - page 12, listing 2
// https://seblagarde.files.wordpress.com/2015/07/course_notes_moving_frostbite_to_pbr_v32.pdf
float G_GGX_SmithCorrelated( const in float alpha, const in float dotNL, const in float dotNV ) {

	float a2 = pow2( alpha );

	// dotNL and dotNV are explicitly swapped. This is not a mistake.
	float gv = dotNL * sqrt( a2 + ( 1.0 - a2 ) * pow2( dotNV ) );
	float gl = dotNV * sqrt( a2 + ( 1.0 - a2 ) * pow2( dotNL ) );

	return 0.5 / max( gv + gl, EPSILON );

}

// Microfacet Models for Refraction through Rough Surfaces - equation (33)
// http://graphicrants.blogspot.com/2013/08/specular-brdf-reference.html
// alpha is "roughness squared" in Disney’s reparameterization
float D_GGX( const in float alpha, const in float dotNH ) {

	float a2 = pow2( alpha );

	float denom = pow2( dotNH ) * ( a2 - 1.0 ) + 1.0; // avoid alpha = 0 with dotNH = 1

	return RECIPROCAL_PI * a2 / pow2( denom );

}

// GGX Distribution, Schlick Fresnel, GGX-Smith Visibility
vec3 BRDF_Specular_GGX( const in IncidentLight incidentLight, const in GeometricContext geometry, const in vec3 specularColor, const in float roughness ) {

	float alpha = pow2( roughness ); // UE4's roughness

	vec3 halfDir = normalize( incidentLight.direction + geometry.viewDir );

	float dotNL = saturate( dot( geometry.normal, incidentLight.direction ) );
	float dotNV = saturate( dot( geometry.normal, geometry.viewDir ) );
	float dotNH = saturate( dot( geometry.normal, halfDir ) );
	float dotLH = saturate( dot( incidentLight.direction, halfDir ) );

	vec3 F = F_Schlick( specularColor, dotLH );

	float G = G_GGX_SmithCorrelated( alpha, dotNL, dotNV );

	float D = D_GGX( alpha, dotNH );

	return F * ( G * D );

} // validated

// Rect Area Light

// Real-Time Polygonal-Light Shading with Linearly Transformed Cosines
// by Eric Heitz, Jonathan Dupuy, Stephen Hill and David Neubelt
// code: https://github.com/selfshadow/ltc_code/

vec2 LTC_Uv( const in vec3 N, const in vec3 V, const in float roughness ) {

	const float LUT_SIZE  = 64.0;
	const float LUT_SCALE = ( LUT_SIZE - 1.0 ) / LUT_SIZE;
	const float LUT_BIAS  = 0.5 / LUT_SIZE;

	float dotNV = saturate( dot( N, V ) );

	// texture parameterized by sqrt( GGX alpha ) and sqrt( 1 - cos( theta ) )
	vec2 uv = vec2( roughness, sqrt( 1.0 - dotNV ) );

	uv = uv * LUT_SCALE + LUT_BIAS;

	return uv;

}

float LTC_ClippedSphereFormFactor( const in vec3 f ) {

	// Real-Time Area Lighting: a Journey from Research to Production (p.102)
	// An approximation of the form factor of a horizon-clipped rectangle.

	float l = length( f );

	return max( ( l * l + f.z ) / ( l + 1.0 ), 0.0 );

}

vec3 LTC_EdgeVectorFormFactor( const in vec3 v1, const in vec3 v2 ) {

	float x = dot( v1, v2 );

	float y = abs( x );

	// rational polynomial approximation to theta / sin( theta ) / 2PI
	float a = 0.8543985 + ( 0.4965155 + 0.0145206 * y ) * y;
	float b = 3.4175940 + ( 4.1616724 + y ) * y;
	float v = a / b;

	float theta_sintheta = ( x > 0.0 ) ? v : 0.5 * inversesqrt( max( 1.0 - x * x, 1e-7 ) ) - v;

	return cross( v1, v2 ) * theta_sintheta;

}

vec3 LTC_Evaluate( const in vec3 N, const in vec3 V, const in vec3 P, const in mat3 mInv, const in vec3 rectCoords[ 4 ] ) {

	// bail if point is on back side of plane of light
	// assumes ccw winding order of light vertices
	vec3 v1 = rectCoords[ 1 ] - rectCoords[ 0 ];
	vec3 v2 = rectCoords[ 3 ] - rectCoords[ 0 ];
	vec3 lightNormal = cross( v1, v2 );

	if( dot( lightNormal, P - rectCoords[ 0 ] ) < 0.0 ) return vec3( 0.0 );

	// construct orthonormal basis around N
	vec3 T1, T2;
	T1 = normalize( V - N * dot( V, N ) );
	T2 = - cross( N, T1 ); // negated from paper; possibly due to a different handedness of world coordinate system

	// compute transform
	mat3 mat = mInv * transposeMat3( mat3( T1, T2, N ) );

	// transform rect
	vec3 coords[ 4 ];
	coords[ 0 ] = mat * ( rectCoords[ 0 ] - P );
	coords[ 1 ] = mat * ( rectCoords[ 1 ] - P );
	coords[ 2 ] = mat * ( rectCoords[ 2 ] - P );
	coords[ 3 ] = mat * ( rectCoords[ 3 ] - P );

	// project rect onto sphere
	coords[ 0 ] = normalize( coords[ 0 ] );
	coords[ 1 ] = normalize( coords[ 1 ] );
	coords[ 2 ] = normalize( coords[ 2 ] );
	coords[ 3 ] = normalize( coords[ 3 ] );

	// calculate vector form factor
	vec3 vectorFormFactor = vec3( 0.0 );
	vectorFormFactor += LTC_EdgeVectorFormFactor( coords[ 0 ], coords[ 1 ] );
	vectorFormFactor += LTC_EdgeVectorFormFactor( coords[ 1 ], coords[ 2 ] );
	vectorFormFactor += LTC_EdgeVectorFormFactor( coords[ 2 ], coords[ 3 ] );
	vectorFormFactor += LTC_EdgeVectorFormFactor( coords[ 3 ], coords[ 0 ] );

	// adjust for horizon clipping
	float result = LTC_ClippedSphereFormFactor( vectorFormFactor );

/*
	// alternate method of adjusting for horizon clipping (see referece)
	// refactoring required
	float len = length( vectorFormFactor );
	float z = vectorFormFactor.z / len;

	const float LUT_SIZE  = 64.0;
	const float LUT_SCALE = ( LUT_SIZE - 1.0 ) / LUT_SIZE;
	const float LUT_BIAS  = 0.5 / LUT_SIZE;

	// tabulated horizon-clipped sphere, apparently...
	vec2 uv = vec2( z * 0.5 + 0.5, len );
	uv = uv * LUT_SCALE + LUT_BIAS;

	float scale = texture2D( ltc_2, uv ).w;

	float result = len * scale;
*/

	return vec3( result );

}

// End Rect Area Light

// ref: https://www.unrealengine.com/blog/physically-based-shading-on-mobile - environmentBRDF for GGX on mobile
vec3 BRDF_Specular_GGX_Environment( const in GeometricContext geometry, const in vec3 specularColor, const in float roughness ) {

	float dotNV = saturate( dot( geometry.normal, geometry.viewDir ) );

	const vec4 c0 = vec4( - 1, - 0.0275, - 0.572, 0.022 );

	const vec4 c1 = vec4( 1, 0.0425, 1.04, - 0.04 );

	vec4 r = roughness * c0 + c1;

	float a004 = min( r.x * r.x, exp2( - 9.28 * dotNV ) ) * r.x + r.y;

	vec2 AB = vec2( -1.04, 1.04 ) * a004 + r.zw;

	return specularColor * AB.x + AB.y;

} // validated


float G_BlinnPhong_Implicit( /* const in float dotNL, const in float dotNV */ ) {

	// geometry term is (n dot l)(n dot v) / 4(n dot l)(n dot v)
	return 0.25;

}

float D_BlinnPhong( const in float shininess, const in float dotNH ) {

	return RECIPROCAL_PI * ( shininess * 0.5 + 1.0 ) * pow( dotNH, shininess );

}

vec3 BRDF_Specular_BlinnPhong( const in IncidentLight incidentLight, const in GeometricContext geometry, const in vec3 specularColor, const in float shininess ) {

	vec3 halfDir = normalize( incidentLight.direction + geometry.viewDir );

	//float dotNL = saturate( dot( geometry.normal, incidentLight.direction ) );
	//float dotNV = saturate( dot( geometry.normal, geometry.viewDir ) );
	float dotNH = saturate( dot( geometry.normal, halfDir ) );
	float dotLH = saturate( dot( incidentLight.direction, halfDir ) );

	vec3 F = F_Schlick( specularColor, dotLH );

	float G = G_BlinnPhong_Implicit( /* dotNL, dotNV */ );

	float D = D_BlinnPhong( shininess, dotNH );

	return F * ( G * D );

} // validated

// source: http://simonstechblog.blogspot.ca/2011/12/microfacet-brdf.html
float GGXRoughnessToBlinnExponent( const in float ggxRoughness ) {
	return ( 2.0 / pow2( ggxRoughness + 0.0001 ) - 2.0 );
}

float BlinnExponentToGGXRoughness( const in float blinnExponent ) {
	return sqrt( 2.0 / ( blinnExponent + 2.0 ) );
}
`,bumpmap_pars_fragment:`
#ifdef USE_BUMPMAP

	uniform sampler2D bumpMap;
	uniform float bumpScale;

	// Bump Mapping Unparametrized Surfaces on the GPU by Morten S. Mikkelsen
	// http://api.unrealengine.com/attachments/Engine/Rendering/LightingAndShadows/BumpMappingWithoutTangentSpace/mm_sfgrad_bump.pdf

	// Evaluate the derivative of the height w.r.t. screen-space using forward differencing (listing 2)

	vec2 dHdxy_fwd() {

		vec2 dSTdx = dFdx( vUv );
		vec2 dSTdy = dFdy( vUv );

		float Hll = bumpScale * texture2D( bumpMap, vUv ).x;
		float dBx = bumpScale * texture2D( bumpMap, vUv + dSTdx ).x - Hll;
		float dBy = bumpScale * texture2D( bumpMap, vUv + dSTdy ).x - Hll;

		return vec2( dBx, dBy );

	}

	vec3 perturbNormalArb( vec3 surf_pos, vec3 surf_norm, vec2 dHdxy ) {

		// Workaround for Adreno 3XX dFd*( vec3 ) bug. See #9988

		vec3 vSigmaX = vec3( dFdx( surf_pos.x ), dFdx( surf_pos.y ), dFdx( surf_pos.z ) );
		vec3 vSigmaY = vec3( dFdy( surf_pos.x ), dFdy( surf_pos.y ), dFdy( surf_pos.z ) );
		vec3 vN = surf_norm;		// normalized

		vec3 R1 = cross( vSigmaY, vN );
		vec3 R2 = cross( vN, vSigmaX );

		float fDet = dot( vSigmaX, R1 );

		fDet *= ( float( gl_FrontFacing ) * 2.0 - 1.0 );

		vec3 vGrad = sign( fDet ) * ( dHdxy.x * R1 + dHdxy.y * R2 );
		return normalize( abs( fDet ) * surf_norm - vGrad );

	}

#endif
`,clipping_planes_fragment:`
#if NUM_CLIPPING_PLANES > 0

	vec4 plane;

	#pragma unroll_loop
	for ( int i = 0; i < UNION_CLIPPING_PLANES; i ++ ) {

		plane = clippingPlanes[ i ];
		if ( dot( vViewPosition, plane.xyz ) > plane.w ) discard;

	}

	#if UNION_CLIPPING_PLANES < NUM_CLIPPING_PLANES

		bool clipped = true;

		#pragma unroll_loop
		for ( int i = UNION_CLIPPING_PLANES; i < NUM_CLIPPING_PLANES; i ++ ) {

			plane = clippingPlanes[ i ];
			clipped = ( dot( vViewPosition, plane.xyz ) > plane.w ) && clipped;

		}

		if ( clipped ) discard;

	#endif

#endif
`,clipping_planes_pars_fragment:`
#if NUM_CLIPPING_PLANES > 0

	#if ! defined( PHYSICAL ) && ! defined( PHONG ) && ! defined( MATCAP )
		varying vec3 vViewPosition;
	#endif

	uniform vec4 clippingPlanes[ NUM_CLIPPING_PLANES ];

#endif
`,clipping_planes_pars_vertex:`
#if NUM_CLIPPING_PLANES > 0 && ! defined( PHYSICAL ) && ! defined( PHONG ) && ! defined( MATCAP )
	varying vec3 vViewPosition;
#endif
`,clipping_planes_vertex:`
#if NUM_CLIPPING_PLANES > 0 && ! defined( PHYSICAL ) && ! defined( PHONG ) && ! defined( MATCAP )
	vViewPosition = - mvPosition.xyz;
#endif
`,color_fragment:`
#ifdef USE_COLOR

	diffuseColor.rgb *= vColor;

#endif
`,color_pars_fragment:`
#ifdef USE_COLOR

	varying vec3 vColor;

#endif
`,color_pars_vertex:`
#ifdef USE_COLOR

	varying vec3 vColor;

#endif
`,color_vertex:`
#ifdef USE_COLOR

	vColor.xyz = color.xyz;

#endif
`,common:`
#define PI 3.14159265359
#define PI2 6.28318530718
#define PI_HALF 1.5707963267949
#define RECIPROCAL_PI 0.31830988618
#define RECIPROCAL_PI2 0.15915494
#define LOG2 1.442695
#define EPSILON 1e-6

#define saturate(a) clamp( a, 0.0, 1.0 )
#define whiteCompliment(a) ( 1.0 - saturate( a ) )

float pow2( const in float x ) { return x*x; }
float pow3( const in float x ) { return x*x*x; }
float pow4( const in float x ) { float x2 = x*x; return x2*x2; }
float average( const in vec3 color ) { return dot( color, vec3( 0.3333 ) ); }
// expects values in the range of [0,1]x[0,1], returns values in the [0,1] range.
// do not collapse into a single function per: http://byteblacksmith.com/improvements-to-the-canonical-one-liner-glsl-rand-for-opengl-es-2-0/
highp float rand( const in vec2 uv ) {
	const highp float a = 12.9898, b = 78.233, c = 43758.5453;
	highp float dt = dot( uv.xy, vec2( a,b ) ), sn = mod( dt, PI );
	return fract(sin(sn) * c);
}

struct IncidentLight {
	vec3 color;
	vec3 direction;
	bool visible;
};

struct ReflectedLight {
	vec3 directDiffuse;
	vec3 directSpecular;
	vec3 indirectDiffuse;
	vec3 indirectSpecular;
};

struct GeometricContext {
	vec3 position;
	vec3 normal;
	vec3 viewDir;
};

vec3 transformDirection( in vec3 dir, in mat4 matrix ) {

	return normalize( ( matrix * vec4( dir, 0.0 ) ).xyz );

}

// http://en.wikibooks.org/wiki/GLSL_Programming/Applying_Matrix_Transformations
vec3 inverseTransformDirection( in vec3 dir, in mat4 matrix ) {

	return normalize( ( vec4( dir, 0.0 ) * matrix ).xyz );

}

vec3 projectOnPlane(in vec3 point, in vec3 pointOnPlane, in vec3 planeNormal ) {

	float distance = dot( planeNormal, point - pointOnPlane );

	return - distance * planeNormal + point;

}

float sideOfPlane( in vec3 point, in vec3 pointOnPlane, in vec3 planeNormal ) {

	return sign( dot( point - pointOnPlane, planeNormal ) );

}

vec3 linePlaneIntersect( in vec3 pointOnLine, in vec3 lineDirection, in vec3 pointOnPlane, in vec3 planeNormal ) {

	return lineDirection * ( dot( planeNormal, pointOnPlane - pointOnLine ) / dot( planeNormal, lineDirection ) ) + pointOnLine;

}

mat3 transposeMat3( const in mat3 m ) {

	mat3 tmp;

	tmp[ 0 ] = vec3( m[ 0 ].x, m[ 1 ].x, m[ 2 ].x );
	tmp[ 1 ] = vec3( m[ 0 ].y, m[ 1 ].y, m[ 2 ].y );
	tmp[ 2 ] = vec3( m[ 0 ].z, m[ 1 ].z, m[ 2 ].z );

	return tmp;

}

// https://en.wikipedia.org/wiki/Relative_luminance
float linearToRelativeLuminance( const in vec3 color ) {

	vec3 weights = vec3( 0.2126, 0.7152, 0.0722 );

	return dot( weights, color.rgb );

}
`,cube_uv_reflection_fragment:`
#ifdef ENVMAP_TYPE_CUBE_UV

#define cubeUV_textureSize (1024.0)

int getFaceFromDirection(vec3 direction) {
	vec3 absDirection = abs(direction);
	int face = -1;
	if( absDirection.x > absDirection.z ) {
		if(absDirection.x > absDirection.y )
			face = direction.x > 0.0 ? 0 : 3;
		else
			face = direction.y > 0.0 ? 1 : 4;
	}
	else {
		if(absDirection.z > absDirection.y )
			face = direction.z > 0.0 ? 2 : 5;
		else
			face = direction.y > 0.0 ? 1 : 4;
	}
	return face;
}
#define cubeUV_maxLods1  (log2(cubeUV_textureSize*0.25) - 1.0)
#define cubeUV_rangeClamp (exp2((6.0 - 1.0) * 2.0))

vec2 MipLevelInfo( vec3 vec, float roughnessLevel, float roughness ) {
	float scale = exp2(cubeUV_maxLods1 - roughnessLevel);
	float dxRoughness = dFdx(roughness);
	float dyRoughness = dFdy(roughness);
	vec3 dx = dFdx( vec * scale * dxRoughness );
	vec3 dy = dFdy( vec * scale * dyRoughness );
	float d = max( dot( dx, dx ), dot( dy, dy ) );
	// Clamp the value to the max mip level counts. hard coded to 6 mips
	d = clamp(d, 1.0, cubeUV_rangeClamp);
	float mipLevel = 0.5 * log2(d);
	return vec2(floor(mipLevel), fract(mipLevel));
}

#define cubeUV_maxLods2 (log2(cubeUV_textureSize*0.25) - 2.0)
#define cubeUV_rcpTextureSize (1.0 / cubeUV_textureSize)

vec2 getCubeUV(vec3 direction, float roughnessLevel, float mipLevel) {
	mipLevel = roughnessLevel > cubeUV_maxLods2 - 3.0 ? 0.0 : mipLevel;
	float a = 16.0 * cubeUV_rcpTextureSize;

	vec2 exp2_packed = exp2( vec2( roughnessLevel, mipLevel ) );
	vec2 rcp_exp2_packed = vec2( 1.0 ) / exp2_packed;
	// float powScale = exp2(roughnessLevel + mipLevel);
	float powScale = exp2_packed.x * exp2_packed.y;
	// float scale =  1.0 / exp2(roughnessLevel + 2.0 + mipLevel);
	float scale = rcp_exp2_packed.x * rcp_exp2_packed.y * 0.25;
	// float mipOffset = 0.75*(1.0 - 1.0/exp2(mipLevel))/exp2(roughnessLevel);
	float mipOffset = 0.75*(1.0 - rcp_exp2_packed.y) * rcp_exp2_packed.x;

	bool bRes = mipLevel == 0.0;
	scale =  bRes && (scale < a) ? a : scale;

	vec3 r;
	vec2 offset;
	int face = getFaceFromDirection(direction);

	float rcpPowScale = 1.0 / powScale;

	if( face == 0) {
		r = vec3(direction.x, -direction.z, direction.y);
		offset = vec2(0.0+mipOffset,0.75 * rcpPowScale);
		offset.y = bRes && (offset.y < 2.0*a) ? a : offset.y;
	}
	else if( face == 1) {
		r = vec3(direction.y, direction.x, direction.z);
		offset = vec2(scale+mipOffset, 0.75 * rcpPowScale);
		offset.y = bRes && (offset.y < 2.0*a) ? a : offset.y;
	}
	else if( face == 2) {
		r = vec3(direction.z, direction.x, direction.y);
		offset = vec2(2.0*scale+mipOffset, 0.75 * rcpPowScale);
		offset.y = bRes && (offset.y < 2.0*a) ? a : offset.y;
	}
	else if( face == 3) {
		r = vec3(direction.x, direction.z, direction.y);
		offset = vec2(0.0+mipOffset,0.5 * rcpPowScale);
		offset.y = bRes && (offset.y < 2.0*a) ? 0.0 : offset.y;
	}
	else if( face == 4) {
		r = vec3(direction.y, direction.x, -direction.z);
		offset = vec2(scale+mipOffset, 0.5 * rcpPowScale);
		offset.y = bRes && (offset.y < 2.0*a) ? 0.0 : offset.y;
	}
	else {
		r = vec3(direction.z, -direction.x, direction.y);
		offset = vec2(2.0*scale+mipOffset, 0.5 * rcpPowScale);
		offset.y = bRes && (offset.y < 2.0*a) ? 0.0 : offset.y;
	}
	r = normalize(r);
	float texelOffset = 0.5 * cubeUV_rcpTextureSize;
	vec2 s = ( r.yz / abs( r.x ) + vec2( 1.0 ) ) * 0.5;
	vec2 base = offset + vec2( texelOffset );
	return base + s * ( scale - 2.0 * texelOffset );
}

#define cubeUV_maxLods3 (log2(cubeUV_textureSize*0.25) - 3.0)

vec4 textureCubeUV( sampler2D envMap, vec3 reflectedDirection, float roughness ) {
	float roughnessVal = roughness* cubeUV_maxLods3;
	float r1 = floor(roughnessVal);
	float r2 = r1 + 1.0;
	float t = fract(roughnessVal);
	vec2 mipInfo = MipLevelInfo(reflectedDirection, r1, roughness);
	float s = mipInfo.y;
	float level0 = mipInfo.x;
	float level1 = level0 + 1.0;
	level1 = level1 > 5.0 ? 5.0 : level1;

	// round to nearest mipmap if we are not interpolating.
	level0 += min( floor( s + 0.5 ), 5.0 );

	// Tri linear interpolation.
	vec2 uv_10 = getCubeUV(reflectedDirection, r1, level0);
	vec4 color10 = envMapTexelToLinear(texture2D(envMap, uv_10));

	vec2 uv_20 = getCubeUV(reflectedDirection, r2, level0);
	vec4 color20 = envMapTexelToLinear(texture2D(envMap, uv_20));

	vec4 result = mix(color10, color20, t);

	return vec4(result.rgb, 1.0);
}

#endif
`,defaultnormal_vertex:`
vec3 transformedNormal = normalMatrix * objectNormal;

#ifdef FLIP_SIDED

	transformedNormal = - transformedNormal;

#endif
`,displacementmap_pars_vertex:`
#ifdef USE_DISPLACEMENTMAP

	uniform sampler2D displacementMap;
	uniform float displacementScale;
	uniform float displacementBias;

#endif
`,displacementmap_vertex:`
#ifdef USE_DISPLACEMENTMAP

	transformed += normalize( objectNormal ) * ( texture2D( displacementMap, uv ).x * displacementScale + displacementBias );

#endif
`,emissivemap_fragment:`
#ifdef USE_EMISSIVEMAP

	vec4 emissiveColor = texture2D( emissiveMap, vUv );

	emissiveColor.rgb = emissiveMapTexelToLinear( emissiveColor ).rgb;

	totalEmissiveRadiance *= emissiveColor.rgb;

#endif
`,emissivemap_pars_fragment:`
#ifdef USE_EMISSIVEMAP

	uniform sampler2D emissiveMap;

#endif
`,encodings_fragment:`
  gl_FragColor = linearToOutputTexel( gl_FragColor );
`,encodings_pars_fragment:`
// For a discussion of what this is, please read this: http://lousodrome.net/blog/light/2013/05/26/gamma-correct-and-hdr-rendering-in-a-32-bits-buffer/

vec4 LinearToLinear( in vec4 value ) {
	return value;
}

vec4 GammaToLinear( in vec4 value, in float gammaFactor ) {
	return vec4( pow( value.rgb, vec3( gammaFactor ) ), value.a );
}

vec4 LinearToGamma( in vec4 value, in float gammaFactor ) {
	return vec4( pow( value.rgb, vec3( 1.0 / gammaFactor ) ), value.a );
}

vec4 sRGBToLinear( in vec4 value ) {
	return vec4( mix( pow( value.rgb * 0.9478672986 + vec3( 0.0521327014 ), vec3( 2.4 ) ), value.rgb * 0.0773993808, vec3( lessThanEqual( value.rgb, vec3( 0.04045 ) ) ) ), value.a );
}

vec4 LinearTosRGB( in vec4 value ) {
	return vec4( mix( pow( value.rgb, vec3( 0.41666 ) ) * 1.055 - vec3( 0.055 ), value.rgb * 12.92, vec3( lessThanEqual( value.rgb, vec3( 0.0031308 ) ) ) ), value.a );
}

vec4 RGBEToLinear( in vec4 value ) {
	return vec4( value.rgb * exp2( value.a * 255.0 - 128.0 ), 1.0 );
}

vec4 LinearToRGBE( in vec4 value ) {
	float maxComponent = max( max( value.r, value.g ), value.b );
	float fExp = clamp( ceil( log2( maxComponent ) ), -128.0, 127.0 );
	return vec4( value.rgb / exp2( fExp ), ( fExp + 128.0 ) / 255.0 );
//  return vec4( value.brg, ( 3.0 + 128.0 ) / 256.0 );
}

// reference: http://iwasbeingirony.blogspot.ca/2010/06/difference-between-rgbm-and-rgbd.html
vec4 RGBMToLinear( in vec4 value, in float maxRange ) {
	return vec4( value.rgb * value.a * maxRange, 1.0 );
}

vec4 LinearToRGBM( in vec4 value, in float maxRange ) {
	float maxRGB = max( value.r, max( value.g, value.b ) );
	float M = clamp( maxRGB / maxRange, 0.0, 1.0 );
	M = ceil( M * 255.0 ) / 255.0;
	return vec4( value.rgb / ( M * maxRange ), M );
}

// reference: http://iwasbeingirony.blogspot.ca/2010/06/difference-between-rgbm-and-rgbd.html
vec4 RGBDToLinear( in vec4 value, in float maxRange ) {
	return vec4( value.rgb * ( ( maxRange / 255.0 ) / value.a ), 1.0 );
}

vec4 LinearToRGBD( in vec4 value, in float maxRange ) {
	float maxRGB = max( value.r, max( value.g, value.b ) );
	float D = max( maxRange / maxRGB, 1.0 );
	D = min( floor( D ) / 255.0, 1.0 );
	return vec4( value.rgb * ( D * ( 255.0 / maxRange ) ), D );
}

// LogLuv reference: http://graphicrants.blogspot.ca/2009/04/rgbm-color-encoding.html

// M matrix, for encoding
const mat3 cLogLuvM = mat3( 0.2209, 0.3390, 0.4184, 0.1138, 0.6780, 0.7319, 0.0102, 0.1130, 0.2969 );
vec4 LinearToLogLuv( in vec4 value )  {
	vec3 Xp_Y_XYZp = value.rgb * cLogLuvM;
	Xp_Y_XYZp = max( Xp_Y_XYZp, vec3( 1e-6, 1e-6, 1e-6 ) );
	vec4 vResult;
	vResult.xy = Xp_Y_XYZp.xy / Xp_Y_XYZp.z;
	float Le = 2.0 * log2(Xp_Y_XYZp.y) + 127.0;
	vResult.w = fract( Le );
	vResult.z = ( Le - ( floor( vResult.w * 255.0 ) ) / 255.0 ) / 255.0;
	return vResult;
}

// Inverse M matrix, for decoding
const mat3 cLogLuvInverseM = mat3( 6.0014, -2.7008, -1.7996, -1.3320, 3.1029, -5.7721, 0.3008, -1.0882, 5.6268 );
vec4 LogLuvToLinear( in vec4 value ) {
	float Le = value.z * 255.0 + value.w;
	vec3 Xp_Y_XYZp;
	Xp_Y_XYZp.y = exp2( ( Le - 127.0 ) / 2.0 );
	Xp_Y_XYZp.z = Xp_Y_XYZp.y / value.y;
	Xp_Y_XYZp.x = value.x * Xp_Y_XYZp.z;
	vec3 vRGB = Xp_Y_XYZp.rgb * cLogLuvInverseM;
	return vec4( max( vRGB, 0.0 ), 1.0 );
}
`,envmap_fragment:`
#ifdef USE_ENVMAP

	#if defined( USE_BUMPMAP ) || defined( USE_NORMALMAP ) || defined( PHONG )

		vec3 cameraToVertex = normalize( vWorldPosition - cameraPosition );

		// Transforming Normal Vectors with the Inverse Transformation
		vec3 worldNormal = inverseTransformDirection( normal, viewMatrix );

		#ifdef ENVMAP_MODE_REFLECTION

			vec3 reflectVec = reflect( cameraToVertex, worldNormal );

		#else

			vec3 reflectVec = refract( cameraToVertex, worldNormal, refractionRatio );

		#endif

	#else

		vec3 reflectVec = vReflect;

	#endif

	#ifdef ENVMAP_TYPE_CUBE

		vec4 envColor = textureCube( envMap, vec3( flipEnvMap * reflectVec.x, reflectVec.yz ) );

	#elif defined( ENVMAP_TYPE_EQUIREC )

		vec2 sampleUV;

		reflectVec = normalize( reflectVec );

		sampleUV.y = asin( clamp( reflectVec.y, - 1.0, 1.0 ) ) * RECIPROCAL_PI + 0.5;

		sampleUV.x = atan( reflectVec.z, reflectVec.x ) * RECIPROCAL_PI2 + 0.5;

		vec4 envColor = texture2D( envMap, sampleUV );

	#elif defined( ENVMAP_TYPE_SPHERE )

		reflectVec = normalize( reflectVec );

		vec3 reflectView = normalize( ( viewMatrix * vec4( reflectVec, 0.0 ) ).xyz + vec3( 0.0, 0.0, 1.0 ) );

		vec4 envColor = texture2D( envMap, reflectView.xy * 0.5 + 0.5 );

	#else

		vec4 envColor = vec4( 0.0 );

	#endif

	envColor = envMapTexelToLinear( envColor );

	#ifdef ENVMAP_BLENDING_MULTIPLY

		outgoingLight = mix( outgoingLight, outgoingLight * envColor.xyz, specularStrength * reflectivity );

	#elif defined( ENVMAP_BLENDING_MIX )

		outgoingLight = mix( outgoingLight, envColor.xyz, specularStrength * reflectivity );

	#elif defined( ENVMAP_BLENDING_ADD )

		outgoingLight += envColor.xyz * specularStrength * reflectivity;

	#endif

#endif
`,envmap_pars_fragment:`
#if defined( USE_ENVMAP ) || defined( PHYSICAL )
	uniform float reflectivity;
	uniform float envMapIntensity;
#endif

#ifdef USE_ENVMAP

	#if ! defined( PHYSICAL ) && ( defined( USE_BUMPMAP ) || defined( USE_NORMALMAP ) || defined( PHONG ) )
		varying vec3 vWorldPosition;
	#endif

	#ifdef ENVMAP_TYPE_CUBE
		uniform samplerCube envMap;
	#else
		uniform sampler2D envMap;
	#endif
	uniform float flipEnvMap;
	uniform int maxMipLevel;

	#if defined( USE_BUMPMAP ) || defined( USE_NORMALMAP ) || defined( PHONG ) || defined( PHYSICAL )
		uniform float refractionRatio;
	#else
		varying vec3 vReflect;
	#endif

#endif
`,envmap_pars_vertex:`
#ifdef USE_ENVMAP

	#if defined( USE_BUMPMAP ) || defined( USE_NORMALMAP ) || defined( PHONG )
		varying vec3 vWorldPosition;

	#else

		varying vec3 vReflect;
		uniform float refractionRatio;

	#endif

#endif
`,envmap_physical_pars_fragment:`
#if defined( USE_ENVMAP ) && defined( PHYSICAL )

	vec3 getLightProbeIndirectIrradiance( /*const in SpecularLightProbe specularLightProbe,*/ const in GeometricContext geometry, const in int maxMIPLevel ) {

		vec3 worldNormal = inverseTransformDirection( geometry.normal, viewMatrix );

		#ifdef ENVMAP_TYPE_CUBE

			vec3 queryVec = vec3( flipEnvMap * worldNormal.x, worldNormal.yz );

			// TODO: replace with properly filtered cubemaps and access the irradiance LOD level, be it the last LOD level
			// of a specular cubemap, or just the default level of a specially created irradiance cubemap.

			#ifdef TEXTURE_LOD_EXT

				vec4 envMapColor = textureCubeLodEXT( envMap, queryVec, float( maxMIPLevel ) );

			#else

				// force the bias high to get the last LOD level as it is the most blurred.
				vec4 envMapColor = textureCube( envMap, queryVec, float( maxMIPLevel ) );

			#endif

			envMapColor.rgb = envMapTexelToLinear( envMapColor ).rgb;

		#elif defined( ENVMAP_TYPE_CUBE_UV )

			vec3 queryVec = vec3( flipEnvMap * worldNormal.x, worldNormal.yz );
			vec4 envMapColor = textureCubeUV( envMap, queryVec, 1.0 );

		#else

			vec4 envMapColor = vec4( 0.0 );

		#endif

		return PI * envMapColor.rgb * envMapIntensity;

	}

	// taken from here: http://casual-effects.blogspot.ca/2011/08/plausible-environment-lighting-in-two.html
	float getSpecularMIPLevel( const in float blinnShininessExponent, const in int maxMIPLevel ) {

		//float envMapWidth = pow( 2.0, maxMIPLevelScalar );
		//float desiredMIPLevel = log2( envMapWidth * sqrt( 3.0 ) ) - 0.5 * log2( pow2( blinnShininessExponent ) + 1.0 );

		float maxMIPLevelScalar = float( maxMIPLevel );
		float desiredMIPLevel = maxMIPLevelScalar + 0.79248 - 0.5 * log2( pow2( blinnShininessExponent ) + 1.0 );

		// clamp to allowable LOD ranges.
		return clamp( desiredMIPLevel, 0.0, maxMIPLevelScalar );

	}

	vec3 getLightProbeIndirectRadiance( /*const in SpecularLightProbe specularLightProbe,*/ const in GeometricContext geometry, const in float blinnShininessExponent, const in int maxMIPLevel ) {

		#ifdef ENVMAP_MODE_REFLECTION

			vec3 reflectVec = reflect( -geometry.viewDir, geometry.normal );

		#else

			vec3 reflectVec = refract( -geometry.viewDir, geometry.normal, refractionRatio );

		#endif

		reflectVec = inverseTransformDirection( reflectVec, viewMatrix );

		float specularMIPLevel = getSpecularMIPLevel( blinnShininessExponent, maxMIPLevel );

		#ifdef ENVMAP_TYPE_CUBE

			vec3 queryReflectVec = vec3( flipEnvMap * reflectVec.x, reflectVec.yz );

			#ifdef TEXTURE_LOD_EXT

				vec4 envMapColor = textureCubeLodEXT( envMap, queryReflectVec, specularMIPLevel );

			#else

				vec4 envMapColor = textureCube( envMap, queryReflectVec, specularMIPLevel );

			#endif

			envMapColor.rgb = envMapTexelToLinear( envMapColor ).rgb;

		#elif defined( ENVMAP_TYPE_CUBE_UV )

			vec3 queryReflectVec = vec3( flipEnvMap * reflectVec.x, reflectVec.yz );
			vec4 envMapColor = textureCubeUV( envMap, queryReflectVec, BlinnExponentToGGXRoughness(blinnShininessExponent ));

		#elif defined( ENVMAP_TYPE_EQUIREC )

			vec2 sampleUV;
			sampleUV.y = asin( clamp( reflectVec.y, - 1.0, 1.0 ) ) * RECIPROCAL_PI + 0.5;
			sampleUV.x = atan( reflectVec.z, reflectVec.x ) * RECIPROCAL_PI2 + 0.5;

			#ifdef TEXTURE_LOD_EXT

				vec4 envMapColor = texture2DLodEXT( envMap, sampleUV, specularMIPLevel );

			#else

				vec4 envMapColor = texture2D( envMap, sampleUV, specularMIPLevel );

			#endif

			envMapColor.rgb = envMapTexelToLinear( envMapColor ).rgb;

		#elif defined( ENVMAP_TYPE_SPHERE )

			vec3 reflectView = normalize( ( viewMatrix * vec4( reflectVec, 0.0 ) ).xyz + vec3( 0.0,0.0,1.0 ) );

			#ifdef TEXTURE_LOD_EXT

				vec4 envMapColor = texture2DLodEXT( envMap, reflectView.xy * 0.5 + 0.5, specularMIPLevel );

			#else

				vec4 envMapColor = texture2D( envMap, reflectView.xy * 0.5 + 0.5, specularMIPLevel );

			#endif

			envMapColor.rgb = envMapTexelToLinear( envMapColor ).rgb;

		#endif

		return envMapColor.rgb * envMapIntensity;

	}

#endif
`,envmap_vertex:`
#ifdef USE_ENVMAP

	#if defined( USE_BUMPMAP ) || defined( USE_NORMALMAP ) || defined( PHONG )

		vWorldPosition = worldPosition.xyz;

	#else

		vec3 cameraToVertex = normalize( worldPosition.xyz - cameraPosition );

		vec3 worldNormal = inverseTransformDirection( transformedNormal, viewMatrix );

		#ifdef ENVMAP_MODE_REFLECTION

			vReflect = reflect( cameraToVertex, worldNormal );

		#else

			vReflect = refract( cameraToVertex, worldNormal, refractionRatio );

		#endif

	#endif

#endif
`,fog_vertex:`
#ifdef USE_FOG

	fogDepth = -mvPosition.z;

#endif
`,fog_pars_vertex:`
#ifdef USE_FOG

	varying float fogDepth;

#endif
`,fog_fragment:`
#ifdef USE_FOG

	#ifdef FOG_EXP2

		float fogFactor = whiteCompliment( exp2( - fogDensity * fogDensity * fogDepth * fogDepth * LOG2 ) );

	#else

		float fogFactor = smoothstep( fogNear, fogFar, fogDepth );

	#endif

	gl_FragColor.rgb = mix( gl_FragColor.rgb, fogColor, fogFactor );

#endif
`,fog_pars_fragment:`
#ifdef USE_FOG

	uniform vec3 fogColor;
	varying float fogDepth;

	#ifdef FOG_EXP2

		uniform float fogDensity;

	#else

		uniform float fogNear;
		uniform float fogFar;

	#endif

#endif
`,gradientmap_pars_fragment:`
#ifdef TOON

	uniform sampler2D gradientMap;

	vec3 getGradientIrradiance( vec3 normal, vec3 lightDirection ) {

		// dotNL will be from -1.0 to 1.0
		float dotNL = dot( normal, lightDirection );
		vec2 coord = vec2( dotNL * 0.5 + 0.5, 0.0 );

		#ifdef USE_GRADIENTMAP

			return texture2D( gradientMap, coord ).rgb;

		#else

			return ( coord.x < 0.7 ) ? vec3( 0.7 ) : vec3( 1.0 );

		#endif


	}

#endif
`,lightmap_fragment:`
#ifdef USE_LIGHTMAP

	reflectedLight.indirectDiffuse += PI * texture2D( lightMap, vUv2 ).xyz * lightMapIntensity; // factor of PI should not be present; included here to prevent breakage

#endif
`,lightmap_pars_fragment:`
#ifdef USE_LIGHTMAP

	uniform sampler2D lightMap;
	uniform float lightMapIntensity;

#endif
`,lights_lambert_vertex:`
vec3 diffuse = vec3( 1.0 );

GeometricContext geometry;
geometry.position = mvPosition.xyz;
geometry.normal = normalize( transformedNormal );
geometry.viewDir = normalize( -mvPosition.xyz );

GeometricContext backGeometry;
backGeometry.position = geometry.position;
backGeometry.normal = -geometry.normal;
backGeometry.viewDir = geometry.viewDir;

vLightFront = vec3( 0.0 );

#ifdef DOUBLE_SIDED
	vLightBack = vec3( 0.0 );
#endif

IncidentLight directLight;
float dotNL;
vec3 directLightColor_Diffuse;

#if NUM_POINT_LIGHTS > 0

	#pragma unroll_loop
	for ( int i = 0; i < NUM_POINT_LIGHTS; i ++ ) {

		getPointDirectLightIrradiance( pointLights[ i ], geometry, directLight );

		dotNL = dot( geometry.normal, directLight.direction );
		directLightColor_Diffuse = PI * directLight.color;

		vLightFront += saturate( dotNL ) * directLightColor_Diffuse;

		#ifdef DOUBLE_SIDED

			vLightBack += saturate( -dotNL ) * directLightColor_Diffuse;

		#endif

	}

#endif

#if NUM_SPOT_LIGHTS > 0

	#pragma unroll_loop
	for ( int i = 0; i < NUM_SPOT_LIGHTS; i ++ ) {

		getSpotDirectLightIrradiance( spotLights[ i ], geometry, directLight );

		dotNL = dot( geometry.normal, directLight.direction );
		directLightColor_Diffuse = PI * directLight.color;

		vLightFront += saturate( dotNL ) * directLightColor_Diffuse;

		#ifdef DOUBLE_SIDED

			vLightBack += saturate( -dotNL ) * directLightColor_Diffuse;

		#endif
	}

#endif

/*
#if NUM_RECT_AREA_LIGHTS > 0

	for ( int i = 0; i < NUM_RECT_AREA_LIGHTS; i ++ ) {

		// TODO (abelnation): implement

	}

#endif
*/

#if NUM_DIR_LIGHTS > 0

	#pragma unroll_loop
	for ( int i = 0; i < NUM_DIR_LIGHTS; i ++ ) {

		getDirectionalDirectLightIrradiance( directionalLights[ i ], geometry, directLight );

		dotNL = dot( geometry.normal, directLight.direction );
		directLightColor_Diffuse = PI * directLight.color;

		vLightFront += saturate( dotNL ) * directLightColor_Diffuse;

		#ifdef DOUBLE_SIDED

			vLightBack += saturate( -dotNL ) * directLightColor_Diffuse;

		#endif

	}

#endif

#if NUM_HEMI_LIGHTS > 0

	#pragma unroll_loop
	for ( int i = 0; i < NUM_HEMI_LIGHTS; i ++ ) {

		vLightFront += getHemisphereLightIrradiance( hemisphereLights[ i ], geometry );

		#ifdef DOUBLE_SIDED

			vLightBack += getHemisphereLightIrradiance( hemisphereLights[ i ], backGeometry );

		#endif

	}

#endif
`,lights_pars_begin:`
uniform vec3 ambientLightColor;

vec3 getAmbientLightIrradiance( const in vec3 ambientLightColor ) {

	vec3 irradiance = ambientLightColor;

	#ifndef PHYSICALLY_CORRECT_LIGHTS

		irradiance *= PI;

	#endif

	return irradiance;

}

#if NUM_DIR_LIGHTS > 0

	struct DirectionalLight {
		vec3 direction;
		vec3 color;

		int shadow;
		float shadowBias;
		float shadowRadius;
		vec2 shadowMapSize;
	};

	uniform DirectionalLight directionalLights[ NUM_DIR_LIGHTS ];

	void getDirectionalDirectLightIrradiance( const in DirectionalLight directionalLight, const in GeometricContext geometry, out IncidentLight directLight ) {

		directLight.color = directionalLight.color;
		directLight.direction = directionalLight.direction;
		directLight.visible = true;

	}

#endif


#if NUM_POINT_LIGHTS > 0

	struct PointLight {
		vec3 position;
		vec3 color;
		float distance;
		float decay;

		int shadow;
		float shadowBias;
		float shadowRadius;
		vec2 shadowMapSize;
		float shadowCameraNear;
		float shadowCameraFar;
	};

	uniform PointLight pointLights[ NUM_POINT_LIGHTS ];

	// directLight is an out parameter as having it as a return value caused compiler errors on some devices
	void getPointDirectLightIrradiance( const in PointLight pointLight, const in GeometricContext geometry, out IncidentLight directLight ) {

		vec3 lVector = pointLight.position - geometry.position;
		directLight.direction = normalize( lVector );

		float lightDistance = length( lVector );

		directLight.color = pointLight.color;
		directLight.color *= punctualLightIntensityToIrradianceFactor( lightDistance, pointLight.distance, pointLight.decay );
		directLight.visible = ( directLight.color != vec3( 0.0 ) );

	}

#endif


#if NUM_SPOT_LIGHTS > 0

	struct SpotLight {
		vec3 position;
		vec3 direction;
		vec3 color;
		float distance;
		float decay;
		float coneCos;
		float penumbraCos;

		int shadow;
		float shadowBias;
		float shadowRadius;
		vec2 shadowMapSize;
	};

	uniform SpotLight spotLights[ NUM_SPOT_LIGHTS ];

	// directLight is an out parameter as having it as a return value caused compiler errors on some devices
	void getSpotDirectLightIrradiance( const in SpotLight spotLight, const in GeometricContext geometry, out IncidentLight directLight  ) {

		vec3 lVector = spotLight.position - geometry.position;
		directLight.direction = normalize( lVector );

		float lightDistance = length( lVector );
		float angleCos = dot( directLight.direction, spotLight.direction );

		if ( angleCos > spotLight.coneCos ) {

			float spotEffect = smoothstep( spotLight.coneCos, spotLight.penumbraCos, angleCos );

			directLight.color = spotLight.color;
			directLight.color *= spotEffect * punctualLightIntensityToIrradianceFactor( lightDistance, spotLight.distance, spotLight.decay );
			directLight.visible = true;

		} else {

			directLight.color = vec3( 0.0 );
			directLight.visible = false;

		}
	}

#endif


#if NUM_RECT_AREA_LIGHTS > 0

	struct RectAreaLight {
		vec3 color;
		vec3 position;
		vec3 halfWidth;
		vec3 halfHeight;
	};

	// Pre-computed values of LinearTransformedCosine approximation of BRDF
	// BRDF approximation Texture is 64x64
	uniform sampler2D ltc_1; // RGBA Float
	uniform sampler2D ltc_2; // RGBA Float

	uniform RectAreaLight rectAreaLights[ NUM_RECT_AREA_LIGHTS ];

#endif


#if NUM_HEMI_LIGHTS > 0

	struct HemisphereLight {
		vec3 direction;
		vec3 skyColor;
		vec3 groundColor;
	};

	uniform HemisphereLight hemisphereLights[ NUM_HEMI_LIGHTS ];

	vec3 getHemisphereLightIrradiance( const in HemisphereLight hemiLight, const in GeometricContext geometry ) {

		float dotNL = dot( geometry.normal, hemiLight.direction );
		float hemiDiffuseWeight = 0.5 * dotNL + 0.5;

		vec3 irradiance = mix( hemiLight.groundColor, hemiLight.skyColor, hemiDiffuseWeight );

		#ifndef PHYSICALLY_CORRECT_LIGHTS

			irradiance *= PI;

		#endif

		return irradiance;

	}

#endif
`,lights_phong_fragment:`
BlinnPhongMaterial material;
material.diffuseColor = diffuseColor.rgb;
material.specularColor = specular;
material.specularShininess = shininess;
material.specularStrength = specularStrength;
`,lights_phong_pars_fragment:`
varying vec3 vViewPosition;

#ifndef FLAT_SHADED

	varying vec3 vNormal;

#endif


struct BlinnPhongMaterial {

	vec3	diffuseColor;
	vec3	specularColor;
	float	specularShininess;
	float	specularStrength;

};

void RE_Direct_BlinnPhong( const in IncidentLight directLight, const in GeometricContext geometry, const in BlinnPhongMaterial material, inout ReflectedLight reflectedLight ) {

	#ifdef TOON

		vec3 irradiance = getGradientIrradiance( geometry.normal, directLight.direction ) * directLight.color;

	#else

		float dotNL = saturate( dot( geometry.normal, directLight.direction ) );
		vec3 irradiance = dotNL * directLight.color;

	#endif

	#ifndef PHYSICALLY_CORRECT_LIGHTS

		irradiance *= PI; // punctual light

	#endif

	reflectedLight.directDiffuse += irradiance * BRDF_Diffuse_Lambert( material.diffuseColor );

	reflectedLight.directSpecular += irradiance * BRDF_Specular_BlinnPhong( directLight, geometry, material.specularColor, material.specularShininess ) * material.specularStrength;

}

void RE_IndirectDiffuse_BlinnPhong( const in vec3 irradiance, const in GeometricContext geometry, const in BlinnPhongMaterial material, inout ReflectedLight reflectedLight ) {

	reflectedLight.indirectDiffuse += irradiance * BRDF_Diffuse_Lambert( material.diffuseColor );

}

#define RE_Direct				RE_Direct_BlinnPhong
#define RE_IndirectDiffuse		RE_IndirectDiffuse_BlinnPhong

#define Material_LightProbeLOD( material )	(0)
`,lights_physical_fragment:`
PhysicalMaterial material;
material.diffuseColor = diffuseColor.rgb * ( 1.0 - metalnessFactor );
material.specularRoughness = clamp( roughnessFactor, 0.04, 1.0 );
#ifdef STANDARD
	material.specularColor = mix( vec3( DEFAULT_SPECULAR_COEFFICIENT ), diffuseColor.rgb, metalnessFactor );
#else
	material.specularColor = mix( vec3( MAXIMUM_SPECULAR_COEFFICIENT * pow2( reflectivity ) ), diffuseColor.rgb, metalnessFactor );
	material.clearCoat = saturate( clearCoat ); // Burley clearcoat model
	material.clearCoatRoughness = clamp( clearCoatRoughness, 0.04, 1.0 );
#endif
`,lights_physical_pars_fragment:`
struct PhysicalMaterial {

	vec3	diffuseColor;
	float	specularRoughness;
	vec3	specularColor;

	#ifndef STANDARD
		float clearCoat;
		float clearCoatRoughness;
	#endif

};

#define MAXIMUM_SPECULAR_COEFFICIENT 0.16
#define DEFAULT_SPECULAR_COEFFICIENT 0.04

// Clear coat directional hemishperical reflectance (this approximation should be improved)
float clearCoatDHRApprox( const in float roughness, const in float dotNL ) {

	return DEFAULT_SPECULAR_COEFFICIENT + ( 1.0 - DEFAULT_SPECULAR_COEFFICIENT ) * ( pow( 1.0 - dotNL, 5.0 ) * pow( 1.0 - roughness, 2.0 ) );

}

#if NUM_RECT_AREA_LIGHTS > 0

	void RE_Direct_RectArea_Physical( const in RectAreaLight rectAreaLight, const in GeometricContext geometry, const in PhysicalMaterial material, inout ReflectedLight reflectedLight ) {

		vec3 normal = geometry.normal;
		vec3 viewDir = geometry.viewDir;
		vec3 position = geometry.position;
		vec3 lightPos = rectAreaLight.position;
		vec3 halfWidth = rectAreaLight.halfWidth;
		vec3 halfHeight = rectAreaLight.halfHeight;
		vec3 lightColor = rectAreaLight.color;
		float roughness = material.specularRoughness;

		vec3 rectCoords[ 4 ];
		rectCoords[ 0 ] = lightPos + halfWidth - halfHeight; // counterclockwise; light shines in local neg z direction
		rectCoords[ 1 ] = lightPos - halfWidth - halfHeight;
		rectCoords[ 2 ] = lightPos - halfWidth + halfHeight;
		rectCoords[ 3 ] = lightPos + halfWidth + halfHeight;

		vec2 uv = LTC_Uv( normal, viewDir, roughness );

		vec4 t1 = texture2D( ltc_1, uv );
		vec4 t2 = texture2D( ltc_2, uv );

		mat3 mInv = mat3(
			vec3( t1.x, 0, t1.y ),
			vec3(    0, 1,    0 ),
			vec3( t1.z, 0, t1.w )
		);

		// LTC Fresnel Approximation by Stephen Hill
		// http://blog.selfshadow.com/publications/s2016-advances/s2016_ltc_fresnel.pdf
		vec3 fresnel = ( material.specularColor * t2.x + ( vec3( 1.0 ) - material.specularColor ) * t2.y );

		reflectedLight.directSpecular += lightColor * fresnel * LTC_Evaluate( normal, viewDir, position, mInv, rectCoords );

		reflectedLight.directDiffuse += lightColor * material.diffuseColor * LTC_Evaluate( normal, viewDir, position, mat3( 1.0 ), rectCoords );

	}

#endif

void RE_Direct_Physical( const in IncidentLight directLight, const in GeometricContext geometry, const in PhysicalMaterial material, inout ReflectedLight reflectedLight ) {

	float dotNL = saturate( dot( geometry.normal, directLight.direction ) );

	vec3 irradiance = dotNL * directLight.color;

	#ifndef PHYSICALLY_CORRECT_LIGHTS

		irradiance *= PI; // punctual light

	#endif

	#ifndef STANDARD
		float clearCoatDHR = material.clearCoat * clearCoatDHRApprox( material.clearCoatRoughness, dotNL );
	#else
		float clearCoatDHR = 0.0;
	#endif

	reflectedLight.directSpecular += ( 1.0 - clearCoatDHR ) * irradiance * BRDF_Specular_GGX( directLight, geometry, material.specularColor, material.specularRoughness );

	reflectedLight.directDiffuse += ( 1.0 - clearCoatDHR ) * irradiance * BRDF_Diffuse_Lambert( material.diffuseColor );

	#ifndef STANDARD

		reflectedLight.directSpecular += irradiance * material.clearCoat * BRDF_Specular_GGX( directLight, geometry, vec3( DEFAULT_SPECULAR_COEFFICIENT ), material.clearCoatRoughness );

	#endif

}

void RE_IndirectDiffuse_Physical( const in vec3 irradiance, const in GeometricContext geometry, const in PhysicalMaterial material, inout ReflectedLight reflectedLight ) {

	reflectedLight.indirectDiffuse += irradiance * BRDF_Diffuse_Lambert( material.diffuseColor );

}

void RE_IndirectSpecular_Physical( const in vec3 radiance, const in vec3 clearCoatRadiance, const in GeometricContext geometry, const in PhysicalMaterial material, inout ReflectedLight reflectedLight ) {

	#ifndef STANDARD
		float dotNV = saturate( dot( geometry.normal, geometry.viewDir ) );
		float dotNL = dotNV;
		float clearCoatDHR = material.clearCoat * clearCoatDHRApprox( material.clearCoatRoughness, dotNL );
	#else
		float clearCoatDHR = 0.0;
	#endif

	reflectedLight.indirectSpecular += ( 1.0 - clearCoatDHR ) * radiance * BRDF_Specular_GGX_Environment( geometry, material.specularColor, material.specularRoughness );

	#ifndef STANDARD

		reflectedLight.indirectSpecular += clearCoatRadiance * material.clearCoat * BRDF_Specular_GGX_Environment( geometry, vec3( DEFAULT_SPECULAR_COEFFICIENT ), material.clearCoatRoughness );

	#endif

}

#define RE_Direct				RE_Direct_Physical
#define RE_Direct_RectArea		RE_Direct_RectArea_Physical
#define RE_IndirectDiffuse		RE_IndirectDiffuse_Physical
#define RE_IndirectSpecular		RE_IndirectSpecular_Physical

#define Material_BlinnShininessExponent( material )   GGXRoughnessToBlinnExponent( material.specularRoughness )
#define Material_ClearCoat_BlinnShininessExponent( material )   GGXRoughnessToBlinnExponent( material.clearCoatRoughness )

// ref: https://seblagarde.files.wordpress.com/2015/07/course_notes_moving_frostbite_to_pbr_v32.pdf
float computeSpecularOcclusion( const in float dotNV, const in float ambientOcclusion, const in float roughness ) {

	return saturate( pow( dotNV + ambientOcclusion, exp2( - 16.0 * roughness - 1.0 ) ) - 1.0 + ambientOcclusion );

}
`,lights_fragment_begin:`
/**
 * This is a template that can be used to light a material, it uses pluggable
 * RenderEquations (RE)for specific lighting scenarios.
 *
 * Instructions for use:
 * - Ensure that both RE_Direct, RE_IndirectDiffuse and RE_IndirectSpecular are defined
 * - If you have defined an RE_IndirectSpecular, you need to also provide a Material_LightProbeLOD. <---- ???
 * - Create a material parameter that is to be passed as the third parameter to your lighting functions.
 *
 * TODO:
 * - Add area light support.
 * - Add sphere light support.
 * - Add diffuse light probe (irradiance cubemap) support.
 */

GeometricContext geometry;

geometry.position = - vViewPosition;
geometry.normal = normal;
geometry.viewDir = normalize( vViewPosition );

IncidentLight directLight;

#if ( NUM_POINT_LIGHTS > 0 ) && defined( RE_Direct )

	PointLight pointLight;

	#pragma unroll_loop
	for ( int i = 0; i < NUM_POINT_LIGHTS; i ++ ) {

		pointLight = pointLights[ i ];

		getPointDirectLightIrradiance( pointLight, geometry, directLight );

		#ifdef USE_SHADOWMAP
		directLight.color *= all( bvec2( pointLight.shadow, directLight.visible ) ) ? getPointShadow( pointShadowMap[ i ], pointLight.shadowMapSize, pointLight.shadowBias, pointLight.shadowRadius, vPointShadowCoord[ i ], pointLight.shadowCameraNear, pointLight.shadowCameraFar ) : 1.0;
		#endif

		RE_Direct( directLight, geometry, material, reflectedLight );

	}

#endif

#if ( NUM_SPOT_LIGHTS > 0 ) && defined( RE_Direct )

	SpotLight spotLight;

	#pragma unroll_loop
	for ( int i = 0; i < NUM_SPOT_LIGHTS; i ++ ) {

		spotLight = spotLights[ i ];

		getSpotDirectLightIrradiance( spotLight, geometry, directLight );

		#ifdef USE_SHADOWMAP
		directLight.color *= all( bvec2( spotLight.shadow, directLight.visible ) ) ? getShadow( spotShadowMap[ i ], spotLight.shadowMapSize, spotLight.shadowBias, spotLight.shadowRadius, vSpotShadowCoord[ i ] ) : 1.0;
		#endif

		RE_Direct( directLight, geometry, material, reflectedLight );

	}

#endif

#if ( NUM_DIR_LIGHTS > 0 ) && defined( RE_Direct )

	DirectionalLight directionalLight;

	#pragma unroll_loop
	for ( int i = 0; i < NUM_DIR_LIGHTS; i ++ ) {

		directionalLight = directionalLights[ i ];

		getDirectionalDirectLightIrradiance( directionalLight, geometry, directLight );

		#ifdef USE_SHADOWMAP
		directLight.color *= all( bvec2( directionalLight.shadow, directLight.visible ) ) ? getShadow( directionalShadowMap[ i ], directionalLight.shadowMapSize, directionalLight.shadowBias, directionalLight.shadowRadius, vDirectionalShadowCoord[ i ] ) : 1.0;
		#endif

		RE_Direct( directLight, geometry, material, reflectedLight );

	}

#endif

#if ( NUM_RECT_AREA_LIGHTS > 0 ) && defined( RE_Direct_RectArea )

	RectAreaLight rectAreaLight;

	#pragma unroll_loop
	for ( int i = 0; i < NUM_RECT_AREA_LIGHTS; i ++ ) {

		rectAreaLight = rectAreaLights[ i ];
		RE_Direct_RectArea( rectAreaLight, geometry, material, reflectedLight );

	}

#endif

#if defined( RE_IndirectDiffuse )

	vec3 irradiance = getAmbientLightIrradiance( ambientLightColor );

	#if ( NUM_HEMI_LIGHTS > 0 )

		#pragma unroll_loop
		for ( int i = 0; i < NUM_HEMI_LIGHTS; i ++ ) {

			irradiance += getHemisphereLightIrradiance( hemisphereLights[ i ], geometry );

		}

	#endif

#endif

#if defined( RE_IndirectSpecular )

	vec3 radiance = vec3( 0.0 );
	vec3 clearCoatRadiance = vec3( 0.0 );

#endif
`,lights_fragment_maps:`
#if defined( RE_IndirectDiffuse )

	#ifdef USE_LIGHTMAP

		vec3 lightMapIrradiance = texture2D( lightMap, vUv2 ).xyz * lightMapIntensity;

		#ifndef PHYSICALLY_CORRECT_LIGHTS

			lightMapIrradiance *= PI; // factor of PI should not be present; included here to prevent breakage

		#endif

		irradiance += lightMapIrradiance;

	#endif

	#if defined( USE_ENVMAP ) && defined( PHYSICAL ) && defined( ENVMAP_TYPE_CUBE_UV )

		irradiance += getLightProbeIndirectIrradiance( /*lightProbe,*/ geometry, maxMipLevel );

	#endif

#endif

#if defined( USE_ENVMAP ) && defined( RE_IndirectSpecular )

	radiance += getLightProbeIndirectRadiance( /*specularLightProbe,*/ geometry, Material_BlinnShininessExponent( material ), maxMipLevel );

	#ifndef STANDARD
		clearCoatRadiance += getLightProbeIndirectRadiance( /*specularLightProbe,*/ geometry, Material_ClearCoat_BlinnShininessExponent( material ), maxMipLevel );
	#endif

#endif
`,lights_fragment_end:`
#if defined( RE_IndirectDiffuse )

	RE_IndirectDiffuse( irradiance, geometry, material, reflectedLight );

#endif

#if defined( RE_IndirectSpecular )

	RE_IndirectSpecular( radiance, clearCoatRadiance, geometry, material, reflectedLight );

#endif
`,logdepthbuf_fragment:`
#if defined( USE_LOGDEPTHBUF ) && defined( USE_LOGDEPTHBUF_EXT )

	gl_FragDepthEXT = log2( vFragDepth ) * logDepthBufFC * 0.5;

#endif
`,logdepthbuf_pars_fragment:`
#if defined( USE_LOGDEPTHBUF ) && defined( USE_LOGDEPTHBUF_EXT )

	uniform float logDepthBufFC;
	varying float vFragDepth;

#endif
`,logdepthbuf_pars_vertex:`
#ifdef USE_LOGDEPTHBUF

	#ifdef USE_LOGDEPTHBUF_EXT

		varying float vFragDepth;

	#else

		uniform float logDepthBufFC;

	#endif

#endif
`,logdepthbuf_vertex:`
#ifdef USE_LOGDEPTHBUF

	#ifdef USE_LOGDEPTHBUF_EXT

		vFragDepth = 1.0 + gl_Position.w;

	#else

		gl_Position.z = log2( max( EPSILON, gl_Position.w + 1.0 ) ) * logDepthBufFC - 1.0;

		gl_Position.z *= gl_Position.w;

	#endif

#endif
`,map_fragment:`
#ifdef USE_MAP

	vec4 texelColor = texture2D( map, vUv );

	texelColor = mapTexelToLinear( texelColor );
	diffuseColor *= texelColor;

#endif
`,map_pars_fragment:`
#ifdef USE_MAP

	uniform sampler2D map;

#endif
`,map_particle_fragment:`
#ifdef USE_MAP

	vec2 uv = ( uvTransform * vec3( gl_PointCoord.x, 1.0 - gl_PointCoord.y, 1 ) ).xy;
	vec4 mapTexel = texture2D( map, uv );
	diffuseColor *= mapTexelToLinear( mapTexel );

#endif
`,map_particle_pars_fragment:`
#ifdef USE_MAP

	uniform mat3 uvTransform;
	uniform sampler2D map;

#endif
`,metalnessmap_fragment:`
float metalnessFactor = metalness;

#ifdef USE_METALNESSMAP

	vec4 texelMetalness = texture2D( metalnessMap, vUv );

	// reads channel B, compatible with a combined OcclusionRoughnessMetallic (RGB) texture
	metalnessFactor *= texelMetalness.b;

#endif
`,metalnessmap_pars_fragment:`
#ifdef USE_METALNESSMAP

	uniform sampler2D metalnessMap;

#endif
`,morphnormal_vertex:`
#ifdef USE_MORPHNORMALS

	objectNormal += ( morphNormal0 - normal ) * morphTargetInfluences[ 0 ];
	objectNormal += ( morphNormal1 - normal ) * morphTargetInfluences[ 1 ];
	objectNormal += ( morphNormal2 - normal ) * morphTargetInfluences[ 2 ];
	objectNormal += ( morphNormal3 - normal ) * morphTargetInfluences[ 3 ];

#endif
`,morphtarget_pars_vertex:`
#ifdef USE_MORPHTARGETS

	#ifndef USE_MORPHNORMALS

	uniform float morphTargetInfluences[ 8 ];

	#else

	uniform float morphTargetInfluences[ 4 ];

	#endif

#endif
`,morphtarget_vertex:`
#ifdef USE_MORPHTARGETS

	transformed += ( morphTarget0 - position ) * morphTargetInfluences[ 0 ];
	transformed += ( morphTarget1 - position ) * morphTargetInfluences[ 1 ];
	transformed += ( morphTarget2 - position ) * morphTargetInfluences[ 2 ];
	transformed += ( morphTarget3 - position ) * morphTargetInfluences[ 3 ];

	#ifndef USE_MORPHNORMALS

	transformed += ( morphTarget4 - position ) * morphTargetInfluences[ 4 ];
	transformed += ( morphTarget5 - position ) * morphTargetInfluences[ 5 ];
	transformed += ( morphTarget6 - position ) * morphTargetInfluences[ 6 ];
	transformed += ( morphTarget7 - position ) * morphTargetInfluences[ 7 ];

	#endif

#endif
`,normal_fragment_begin:`
#ifdef FLAT_SHADED

	// Workaround for Adreno/Nexus5 not able able to do dFdx( vViewPosition ) ...

	vec3 fdx = vec3( dFdx( vViewPosition.x ), dFdx( vViewPosition.y ), dFdx( vViewPosition.z ) );
	vec3 fdy = vec3( dFdy( vViewPosition.x ), dFdy( vViewPosition.y ), dFdy( vViewPosition.z ) );
	vec3 normal = normalize( cross( fdx, fdy ) );

#else

	vec3 normal = normalize( vNormal );

	#ifdef DOUBLE_SIDED

		normal = normal * ( float( gl_FrontFacing ) * 2.0 - 1.0 );

	#endif

#endif
`,normal_fragment_maps:`
#ifdef USE_NORMALMAP

	#ifdef OBJECTSPACE_NORMALMAP

		normal = texture2D( normalMap, vUv ).xyz * 2.0 - 1.0; // overrides both flatShading and attribute normals

		#ifdef FLIP_SIDED

			normal = - normal;

		#endif

		#ifdef DOUBLE_SIDED

			normal = normal * ( float( gl_FrontFacing ) * 2.0 - 1.0 );

		#endif

		normal = normalize( normalMatrix * normal );

	#else // tangent-space normal map

		normal = perturbNormal2Arb( -vViewPosition, normal );

	#endif

#elif defined( USE_BUMPMAP )

	normal = perturbNormalArb( -vViewPosition, normal, dHdxy_fwd() );

#endif
`,normalmap_pars_fragment:`
#ifdef USE_NORMALMAP

	uniform sampler2D normalMap;
	uniform vec2 normalScale;

	#ifdef OBJECTSPACE_NORMALMAP

		uniform mat3 normalMatrix;

	#else

		// Per-Pixel Tangent Space Normal Mapping
		// http://hacksoflife.blogspot.ch/2009/11/per-pixel-tangent-space-normal-mapping.html

		vec3 perturbNormal2Arb( vec3 eye_pos, vec3 surf_norm ) {

			// Workaround for Adreno 3XX dFd*( vec3 ) bug. See #9988

			vec3 q0 = vec3( dFdx( eye_pos.x ), dFdx( eye_pos.y ), dFdx( eye_pos.z ) );
			vec3 q1 = vec3( dFdy( eye_pos.x ), dFdy( eye_pos.y ), dFdy( eye_pos.z ) );
			vec2 st0 = dFdx( vUv.st );
			vec2 st1 = dFdy( vUv.st );

			float scale = sign( st1.t * st0.s - st0.t * st1.s ); // we do not care about the magnitude

			vec3 S = normalize( ( q0 * st1.t - q1 * st0.t ) * scale );
			vec3 T = normalize( ( - q0 * st1.s + q1 * st0.s ) * scale );
			vec3 N = normalize( surf_norm );
			mat3 tsn = mat3( S, T, N );

			vec3 mapN = texture2D( normalMap, vUv ).xyz * 2.0 - 1.0;

			mapN.xy *= normalScale;
			mapN.xy *= ( float( gl_FrontFacing ) * 2.0 - 1.0 );

			return normalize( tsn * mapN );

		}

	#endif

#endif
`,packing:`
vec3 packNormalToRGB( const in vec3 normal ) {
	return normalize( normal ) * 0.5 + 0.5;
}

vec3 unpackRGBToNormal( const in vec3 rgb ) {
	return 2.0 * rgb.xyz - 1.0;
}

const float PackUpscale = 256. / 255.; // fraction -> 0..1 (including 1)
const float UnpackDownscale = 255. / 256.; // 0..1 -> fraction (excluding 1)

const vec3 PackFactors = vec3( 256. * 256. * 256., 256. * 256.,  256. );
const vec4 UnpackFactors = UnpackDownscale / vec4( PackFactors, 1. );

const float ShiftRight8 = 1. / 256.;

vec4 packDepthToRGBA( const in float v ) {
	vec4 r = vec4( fract( v * PackFactors ), v );
	r.yzw -= r.xyz * ShiftRight8; // tidy overflow
	return r * PackUpscale;
}

float unpackRGBAToDepth( const in vec4 v ) {
	return dot( v, UnpackFactors );
}

// NOTE: viewZ/eyeZ is < 0 when in front of the camera per OpenGL conventions

float viewZToOrthographicDepth( const in float viewZ, const in float near, const in float far ) {
	return ( viewZ + near ) / ( near - far );
}
float orthographicDepthToViewZ( const in float linearClipZ, const in float near, const in float far ) {
	return linearClipZ * ( near - far ) - near;
}

float viewZToPerspectiveDepth( const in float viewZ, const in float near, const in float far ) {
	return (( near + viewZ ) * far ) / (( far - near ) * viewZ );
}
float perspectiveDepthToViewZ( const in float invClipZ, const in float near, const in float far ) {
	return ( near * far ) / ( ( far - near ) * invClipZ - far );
}
`,premultiplied_alpha_fragment:`
#ifdef PREMULTIPLIED_ALPHA

	// Get get normal blending with premultipled, use with CustomBlending, OneFactor, OneMinusSrcAlphaFactor, AddEquation.
	gl_FragColor.rgb *= gl_FragColor.a;

#endif
`,project_vertex:`
vec4 mvPosition = modelViewMatrix * vec4( transformed, 1.0 );

gl_Position = projectionMatrix * mvPosition;
`,dithering_fragment:`
#if defined( DITHERING )

  gl_FragColor.rgb = dithering( gl_FragColor.rgb );

#endif
`,dithering_pars_fragment:`
#if defined( DITHERING )

	// based on https://www.shadertoy.com/view/MslGR8
	vec3 dithering( vec3 color ) {
		//Calculate grid position
		float grid_position = rand( gl_FragCoord.xy );

		//Shift the individual colors differently, thus making it even harder to see the dithering pattern
		vec3 dither_shift_RGB = vec3( 0.25 / 255.0, -0.25 / 255.0, 0.25 / 255.0 );

		//modify shift acording to grid position.
		dither_shift_RGB = mix( 2.0 * dither_shift_RGB, -2.0 * dither_shift_RGB, grid_position );

		//shift the color by dither_shift
		return color + dither_shift_RGB;
	}

#endif
`,roughnessmap_fragment:`
float roughnessFactor = roughness;

#ifdef USE_ROUGHNESSMAP

	vec4 texelRoughness = texture2D( roughnessMap, vUv );

	// reads channel G, compatible with a combined OcclusionRoughnessMetallic (RGB) texture
	roughnessFactor *= texelRoughness.g;

#endif
`,roughnessmap_pars_fragment:`
#ifdef USE_ROUGHNESSMAP

	uniform sampler2D roughnessMap;

#endif
`,shadowmap_pars_fragment:`
#ifdef USE_SHADOWMAP

	#if NUM_DIR_LIGHTS > 0

		uniform sampler2D directionalShadowMap[ NUM_DIR_LIGHTS ];
		varying vec4 vDirectionalShadowCoord[ NUM_DIR_LIGHTS ];

	#endif

	#if NUM_SPOT_LIGHTS > 0

		uniform sampler2D spotShadowMap[ NUM_SPOT_LIGHTS ];
		varying vec4 vSpotShadowCoord[ NUM_SPOT_LIGHTS ];

	#endif

	#if NUM_POINT_LIGHTS > 0

		uniform sampler2D pointShadowMap[ NUM_POINT_LIGHTS ];
		varying vec4 vPointShadowCoord[ NUM_POINT_LIGHTS ];

	#endif

	/*
	#if NUM_RECT_AREA_LIGHTS > 0

		// TODO (abelnation): create uniforms for area light shadows

	#endif
	*/

	float texture2DCompare( sampler2D depths, vec2 uv, float compare ) {

		return step( compare, unpackRGBAToDepth( texture2D( depths, uv ) ) );

	}

	float texture2DShadowLerp( sampler2D depths, vec2 size, vec2 uv, float compare ) {

		const vec2 offset = vec2( 0.0, 1.0 );

		vec2 texelSize = vec2( 1.0 ) / size;
		vec2 centroidUV = floor( uv * size + 0.5 ) / size;

		float lb = texture2DCompare( depths, centroidUV + texelSize * offset.xx, compare );
		float lt = texture2DCompare( depths, centroidUV + texelSize * offset.xy, compare );
		float rb = texture2DCompare( depths, centroidUV + texelSize * offset.yx, compare );
		float rt = texture2DCompare( depths, centroidUV + texelSize * offset.yy, compare );

		vec2 f = fract( uv * size + 0.5 );

		float a = mix( lb, lt, f.y );
		float b = mix( rb, rt, f.y );
		float c = mix( a, b, f.x );

		return c;

	}

	float getShadow( sampler2D shadowMap, vec2 shadowMapSize, float shadowBias, float shadowRadius, vec4 shadowCoord ) {

		float shadow = 1.0;

		shadowCoord.xyz /= shadowCoord.w;
		shadowCoord.z += shadowBias;

		// if ( something && something ) breaks ATI OpenGL shader compiler
		// if ( all( something, something ) ) using this instead

		bvec4 inFrustumVec = bvec4 ( shadowCoord.x >= 0.0, shadowCoord.x <= 1.0, shadowCoord.y >= 0.0, shadowCoord.y <= 1.0 );
		bool inFrustum = all( inFrustumVec );

		bvec2 frustumTestVec = bvec2( inFrustum, shadowCoord.z <= 1.0 );

		bool frustumTest = all( frustumTestVec );

		if ( frustumTest ) {

		#if defined( SHADOWMAP_TYPE_PCF )

			vec2 texelSize = vec2( 1.0 ) / shadowMapSize;

			float dx0 = - texelSize.x * shadowRadius;
			float dy0 = - texelSize.y * shadowRadius;
			float dx1 = + texelSize.x * shadowRadius;
			float dy1 = + texelSize.y * shadowRadius;

			shadow = (
				texture2DCompare( shadowMap, shadowCoord.xy + vec2( dx0, dy0 ), shadowCoord.z ) +
				texture2DCompare( shadowMap, shadowCoord.xy + vec2( 0.0, dy0 ), shadowCoord.z ) +
				texture2DCompare( shadowMap, shadowCoord.xy + vec2( dx1, dy0 ), shadowCoord.z ) +
				texture2DCompare( shadowMap, shadowCoord.xy + vec2( dx0, 0.0 ), shadowCoord.z ) +
				texture2DCompare( shadowMap, shadowCoord.xy, shadowCoord.z ) +
				texture2DCompare( shadowMap, shadowCoord.xy + vec2( dx1, 0.0 ), shadowCoord.z ) +
				texture2DCompare( shadowMap, shadowCoord.xy + vec2( dx0, dy1 ), shadowCoord.z ) +
				texture2DCompare( shadowMap, shadowCoord.xy + vec2( 0.0, dy1 ), shadowCoord.z ) +
				texture2DCompare( shadowMap, shadowCoord.xy + vec2( dx1, dy1 ), shadowCoord.z )
			) * ( 1.0 / 9.0 );

		#elif defined( SHADOWMAP_TYPE_PCF_SOFT )

			vec2 texelSize = vec2( 1.0 ) / shadowMapSize;

			float dx0 = - texelSize.x * shadowRadius;
			float dy0 = - texelSize.y * shadowRadius;
			float dx1 = + texelSize.x * shadowRadius;
			float dy1 = + texelSize.y * shadowRadius;

			shadow = (
				texture2DShadowLerp( shadowMap, shadowMapSize, shadowCoord.xy + vec2( dx0, dy0 ), shadowCoord.z ) +
				texture2DShadowLerp( shadowMap, shadowMapSize, shadowCoord.xy + vec2( 0.0, dy0 ), shadowCoord.z ) +
				texture2DShadowLerp( shadowMap, shadowMapSize, shadowCoord.xy + vec2( dx1, dy0 ), shadowCoord.z ) +
				texture2DShadowLerp( shadowMap, shadowMapSize, shadowCoord.xy + vec2( dx0, 0.0 ), shadowCoord.z ) +
				texture2DShadowLerp( shadowMap, shadowMapSize, shadowCoord.xy, shadowCoord.z ) +
				texture2DShadowLerp( shadowMap, shadowMapSize, shadowCoord.xy + vec2( dx1, 0.0 ), shadowCoord.z ) +
				texture2DShadowLerp( shadowMap, shadowMapSize, shadowCoord.xy + vec2( dx0, dy1 ), shadowCoord.z ) +
				texture2DShadowLerp( shadowMap, shadowMapSize, shadowCoord.xy + vec2( 0.0, dy1 ), shadowCoord.z ) +
				texture2DShadowLerp( shadowMap, shadowMapSize, shadowCoord.xy + vec2( dx1, dy1 ), shadowCoord.z )
			) * ( 1.0 / 9.0 );

		#else // no percentage-closer filtering:

			shadow = texture2DCompare( shadowMap, shadowCoord.xy, shadowCoord.z );

		#endif

		}

		return shadow;

	}

	// cubeToUV() maps a 3D direction vector suitable for cube texture mapping to a 2D
	// vector suitable for 2D texture mapping. This code uses the following layout for the
	// 2D texture:
	//
	// xzXZ
	//  y Y
	//
	// Y - Positive y direction
	// y - Negative y direction
	// X - Positive x direction
	// x - Negative x direction
	// Z - Positive z direction
	// z - Negative z direction
	//
	// Source and test bed:
	// https://gist.github.com/tschw/da10c43c467ce8afd0c4

	vec2 cubeToUV( vec3 v, float texelSizeY ) {

		// Number of texels to avoid at the edge of each square

		vec3 absV = abs( v );

		// Intersect unit cube

		float scaleToCube = 1.0 / max( absV.x, max( absV.y, absV.z ) );
		absV *= scaleToCube;

		// Apply scale to avoid seams

		// two texels less per square (one texel will do for NEAREST)
		v *= scaleToCube * ( 1.0 - 2.0 * texelSizeY );

		// Unwrap

		// space: -1 ... 1 range for each square
		//
		// #X##		dim    := ( 4 , 2 )
		//  # #		center := ( 1 , 1 )

		vec2 planar = v.xy;

		float almostATexel = 1.5 * texelSizeY;
		float almostOne = 1.0 - almostATexel;

		if ( absV.z >= almostOne ) {

			if ( v.z > 0.0 )
				planar.x = 4.0 - v.x;

		} else if ( absV.x >= almostOne ) {

			float signX = sign( v.x );
			planar.x = v.z * signX + 2.0 * signX;

		} else if ( absV.y >= almostOne ) {

			float signY = sign( v.y );
			planar.x = v.x + 2.0 * signY + 2.0;
			planar.y = v.z * signY - 2.0;

		}

		// Transform to UV space

		// scale := 0.5 / dim
		// translate := ( center + 0.5 ) / dim
		return vec2( 0.125, 0.25 ) * planar + vec2( 0.375, 0.75 );

	}

	float getPointShadow( sampler2D shadowMap, vec2 shadowMapSize, float shadowBias, float shadowRadius, vec4 shadowCoord, float shadowCameraNear, float shadowCameraFar ) {

		vec2 texelSize = vec2( 1.0 ) / ( shadowMapSize * vec2( 4.0, 2.0 ) );

		// for point lights, the uniform @vShadowCoord is re-purposed to hold
		// the vector from the light to the world-space position of the fragment.
		vec3 lightToPosition = shadowCoord.xyz;

		// dp = normalized distance from light to fragment position
		float dp = ( length( lightToPosition ) - shadowCameraNear ) / ( shadowCameraFar - shadowCameraNear ); // need to clamp?
		dp += shadowBias;

		// bd3D = base direction 3D
		vec3 bd3D = normalize( lightToPosition );

		#if defined( SHADOWMAP_TYPE_PCF ) || defined( SHADOWMAP_TYPE_PCF_SOFT )

			vec2 offset = vec2( - 1, 1 ) * shadowRadius * texelSize.y;

			return (
				texture2DCompare( shadowMap, cubeToUV( bd3D + offset.xyy, texelSize.y ), dp ) +
				texture2DCompare( shadowMap, cubeToUV( bd3D + offset.yyy, texelSize.y ), dp ) +
				texture2DCompare( shadowMap, cubeToUV( bd3D + offset.xyx, texelSize.y ), dp ) +
				texture2DCompare( shadowMap, cubeToUV( bd3D + offset.yyx, texelSize.y ), dp ) +
				texture2DCompare( shadowMap, cubeToUV( bd3D, texelSize.y ), dp ) +
				texture2DCompare( shadowMap, cubeToUV( bd3D + offset.xxy, texelSize.y ), dp ) +
				texture2DCompare( shadowMap, cubeToUV( bd3D + offset.yxy, texelSize.y ), dp ) +
				texture2DCompare( shadowMap, cubeToUV( bd3D + offset.xxx, texelSize.y ), dp ) +
				texture2DCompare( shadowMap, cubeToUV( bd3D + offset.yxx, texelSize.y ), dp )
			) * ( 1.0 / 9.0 );

		#else // no percentage-closer filtering

			return texture2DCompare( shadowMap, cubeToUV( bd3D, texelSize.y ), dp );

		#endif

	}

#endif
`,shadowmap_pars_vertex:`
#ifdef USE_SHADOWMAP

	#if NUM_DIR_LIGHTS > 0

		uniform mat4 directionalShadowMatrix[ NUM_DIR_LIGHTS ];
		varying vec4 vDirectionalShadowCoord[ NUM_DIR_LIGHTS ];

	#endif

	#if NUM_SPOT_LIGHTS > 0

		uniform mat4 spotShadowMatrix[ NUM_SPOT_LIGHTS ];
		varying vec4 vSpotShadowCoord[ NUM_SPOT_LIGHTS ];

	#endif

	#if NUM_POINT_LIGHTS > 0

		uniform mat4 pointShadowMatrix[ NUM_POINT_LIGHTS ];
		varying vec4 vPointShadowCoord[ NUM_POINT_LIGHTS ];

	#endif

	/*
	#if NUM_RECT_AREA_LIGHTS > 0

		// TODO (abelnation): uniforms for area light shadows

	#endif
	*/

#endif
`,shadowmap_vertex:`
#ifdef USE_SHADOWMAP

	#if NUM_DIR_LIGHTS > 0

	#pragma unroll_loop
	for ( int i = 0; i < NUM_DIR_LIGHTS; i ++ ) {

		vDirectionalShadowCoord[ i ] = directionalShadowMatrix[ i ] * worldPosition;

	}

	#endif

	#if NUM_SPOT_LIGHTS > 0

	#pragma unroll_loop
	for ( int i = 0; i < NUM_SPOT_LIGHTS; i ++ ) {

		vSpotShadowCoord[ i ] = spotShadowMatrix[ i ] * worldPosition;

	}

	#endif

	#if NUM_POINT_LIGHTS > 0

	#pragma unroll_loop
	for ( int i = 0; i < NUM_POINT_LIGHTS; i ++ ) {

		vPointShadowCoord[ i ] = pointShadowMatrix[ i ] * worldPosition;

	}

	#endif

	/*
	#if NUM_RECT_AREA_LIGHTS > 0

		// TODO (abelnation): update vAreaShadowCoord with area light info

	#endif
	*/

#endif
`,shadowmask_pars_fragment:`
float getShadowMask() {

	float shadow = 1.0;

	#ifdef USE_SHADOWMAP

	#if NUM_DIR_LIGHTS > 0

	DirectionalLight directionalLight;

	#pragma unroll_loop
	for ( int i = 0; i < NUM_DIR_LIGHTS; i ++ ) {

		directionalLight = directionalLights[ i ];
		shadow *= bool( directionalLight.shadow ) ? getShadow( directionalShadowMap[ i ], directionalLight.shadowMapSize, directionalLight.shadowBias, directionalLight.shadowRadius, vDirectionalShadowCoord[ i ] ) : 1.0;

	}

	#endif

	#if NUM_SPOT_LIGHTS > 0

	SpotLight spotLight;

	#pragma unroll_loop
	for ( int i = 0; i < NUM_SPOT_LIGHTS; i ++ ) {

		spotLight = spotLights[ i ];
		shadow *= bool( spotLight.shadow ) ? getShadow( spotShadowMap[ i ], spotLight.shadowMapSize, spotLight.shadowBias, spotLight.shadowRadius, vSpotShadowCoord[ i ] ) : 1.0;

	}

	#endif

	#if NUM_POINT_LIGHTS > 0

	PointLight pointLight;

	#pragma unroll_loop
	for ( int i = 0; i < NUM_POINT_LIGHTS; i ++ ) {

		pointLight = pointLights[ i ];
		shadow *= bool( pointLight.shadow ) ? getPointShadow( pointShadowMap[ i ], pointLight.shadowMapSize, pointLight.shadowBias, pointLight.shadowRadius, vPointShadowCoord[ i ], pointLight.shadowCameraNear, pointLight.shadowCameraFar ) : 1.0;

	}

	#endif

	/*
	#if NUM_RECT_AREA_LIGHTS > 0

		// TODO (abelnation): update shadow for Area light

	#endif
	*/

	#endif

	return shadow;

}
`,skinbase_vertex:`
#ifdef USE_SKINNING

	mat4 boneMatX = getBoneMatrix( skinIndex.x );
	mat4 boneMatY = getBoneMatrix( skinIndex.y );
	mat4 boneMatZ = getBoneMatrix( skinIndex.z );
	mat4 boneMatW = getBoneMatrix( skinIndex.w );

#endif
`,skinning_pars_vertex:`
#ifdef USE_SKINNING

	uniform mat4 bindMatrix;
	uniform mat4 bindMatrixInverse;

	#ifdef BONE_TEXTURE

		uniform sampler2D boneTexture;
		uniform int boneTextureSize;

		mat4 getBoneMatrix( const in float i ) {

			float j = i * 4.0;
			float x = mod( j, float( boneTextureSize ) );
			float y = floor( j / float( boneTextureSize ) );

			float dx = 1.0 / float( boneTextureSize );
			float dy = 1.0 / float( boneTextureSize );

			y = dy * ( y + 0.5 );

			vec4 v1 = texture2D( boneTexture, vec2( dx * ( x + 0.5 ), y ) );
			vec4 v2 = texture2D( boneTexture, vec2( dx * ( x + 1.5 ), y ) );
			vec4 v3 = texture2D( boneTexture, vec2( dx * ( x + 2.5 ), y ) );
			vec4 v4 = texture2D( boneTexture, vec2( dx * ( x + 3.5 ), y ) );

			mat4 bone = mat4( v1, v2, v3, v4 );

			return bone;

		}

	#else

		uniform mat4 boneMatrices[ MAX_BONES ];

		mat4 getBoneMatrix( const in float i ) {

			mat4 bone = boneMatrices[ int(i) ];
			return bone;

		}

	#endif

#endif
`,skinning_vertex:`
#ifdef USE_SKINNING

	vec4 skinVertex = bindMatrix * vec4( transformed, 1.0 );

	vec4 skinned = vec4( 0.0 );
	skinned += boneMatX * skinVertex * skinWeight.x;
	skinned += boneMatY * skinVertex * skinWeight.y;
	skinned += boneMatZ * skinVertex * skinWeight.z;
	skinned += boneMatW * skinVertex * skinWeight.w;

	transformed = ( bindMatrixInverse * skinned ).xyz;

#endif
`,skinnormal_vertex:`
#ifdef USE_SKINNING

	mat4 skinMatrix = mat4( 0.0 );
	skinMatrix += skinWeight.x * boneMatX;
	skinMatrix += skinWeight.y * boneMatY;
	skinMatrix += skinWeight.z * boneMatZ;
	skinMatrix += skinWeight.w * boneMatW;
	skinMatrix  = bindMatrixInverse * skinMatrix * bindMatrix;

	objectNormal = vec4( skinMatrix * vec4( objectNormal, 0.0 ) ).xyz;

#endif
`,specularmap_fragment:`
float specularStrength;

#ifdef USE_SPECULARMAP

	vec4 texelSpecular = texture2D( specularMap, vUv );
	specularStrength = texelSpecular.r;

#else

	specularStrength = 1.0;

#endif
`,specularmap_pars_fragment:`
#ifdef USE_SPECULARMAP

	uniform sampler2D specularMap;

#endif
`,tonemapping_fragment:`
#if defined( TONE_MAPPING )

  gl_FragColor.rgb = toneMapping( gl_FragColor.rgb );

#endif
`,tonemapping_pars_fragment:`
#ifndef saturate
	#define saturate(a) clamp( a, 0.0, 1.0 )
#endif

uniform float toneMappingExposure;
uniform float toneMappingWhitePoint;

// exposure only
vec3 LinearToneMapping( vec3 color ) {

	return toneMappingExposure * color;

}

// source: https://www.cs.utah.edu/~reinhard/cdrom/
vec3 ReinhardToneMapping( vec3 color ) {

	color *= toneMappingExposure;
	return saturate( color / ( vec3( 1.0 ) + color ) );

}

// source: http://filmicgames.com/archives/75
#define Uncharted2Helper( x ) max( ( ( x * ( 0.15 * x + 0.10 * 0.50 ) + 0.20 * 0.02 ) / ( x * ( 0.15 * x + 0.50 ) + 0.20 * 0.30 ) ) - 0.02 / 0.30, vec3( 0.0 ) )
vec3 Uncharted2ToneMapping( vec3 color ) {

	// John Hable's filmic operator from Uncharted 2 video game
	color *= toneMappingExposure;
	return saturate( Uncharted2Helper( color ) / Uncharted2Helper( vec3( toneMappingWhitePoint ) ) );

}

// source: http://filmicgames.com/archives/75
vec3 OptimizedCineonToneMapping( vec3 color ) {

	// optimized filmic operator by Jim Hejl and Richard Burgess-Dawson
	color *= toneMappingExposure;
	color = max( vec3( 0.0 ), color - 0.004 );
	return pow( ( color * ( 6.2 * color + 0.5 ) ) / ( color * ( 6.2 * color + 1.7 ) + 0.06 ), vec3( 2.2 ) );

}

// source: https://knarkowicz.wordpress.com/2016/01/06/aces-filmic-tone-mapping-curve/
vec3 ACESFilmicToneMapping( vec3 color ) {

	color *= toneMappingExposure;
	return saturate( ( color * ( 2.51 * color + 0.03 ) ) / ( color * ( 2.43 * color + 0.59 ) + 0.14 ) );

}
`,uv_pars_fragment:`
#if defined( USE_MAP ) || defined( USE_BUMPMAP ) || defined( USE_NORMALMAP ) || defined( USE_SPECULARMAP ) || defined( USE_ALPHAMAP ) || defined( USE_EMISSIVEMAP ) || defined( USE_ROUGHNESSMAP ) || defined( USE_METALNESSMAP )

	varying vec2 vUv;

#endif
`,uv_pars_vertex:`
#if defined( USE_MAP ) || defined( USE_BUMPMAP ) || defined( USE_NORMALMAP ) || defined( USE_SPECULARMAP ) || defined( USE_ALPHAMAP ) || defined( USE_EMISSIVEMAP ) || defined( USE_ROUGHNESSMAP ) || defined( USE_METALNESSMAP )

	varying vec2 vUv;
	uniform mat3 uvTransform;

#endif
`,uv_vertex:`
#if defined( USE_MAP ) || defined( USE_BUMPMAP ) || defined( USE_NORMALMAP ) || defined( USE_SPECULARMAP ) || defined( USE_ALPHAMAP ) || defined( USE_EMISSIVEMAP ) || defined( USE_ROUGHNESSMAP ) || defined( USE_METALNESSMAP )

	vUv = ( uvTransform * vec3( uv, 1 ) ).xy;

#endif
`,uv2_pars_fragment:`
#if defined( USE_LIGHTMAP ) || defined( USE_AOMAP )

	varying vec2 vUv2;

#endif
`,uv2_pars_vertex:`
#if defined( USE_LIGHTMAP ) || defined( USE_AOMAP )

	attribute vec2 uv2;
	varying vec2 vUv2;

#endif
`,uv2_vertex:`
#if defined( USE_LIGHTMAP ) || defined( USE_AOMAP )

	vUv2 = uv2;

#endif
`,worldpos_vertex:`
#if defined( USE_ENVMAP ) || defined( DISTANCE ) || defined ( USE_SHADOWMAP )

	vec4 worldPosition = modelMatrix * vec4( transformed, 1.0 );

#endif
`,background_frag:`
uniform sampler2D t2D;

varying vec2 vUv;

void main() {

	vec4 texColor = texture2D( t2D, vUv );

	gl_FragColor = mapTexelToLinear( texColor );

	#include <tonemapping_fragment>
	#include <encodings_fragment>

}
`,background_vert:`
varying vec2 vUv;
uniform mat3 uvTransform;

void main() {

	vUv = ( uvTransform * vec3( uv, 1 ) ).xy;

	gl_Position = vec4( position.xy, 1.0, 1.0 );

}
`,cube_frag:`
uniform samplerCube tCube;
uniform float tFlip;
uniform float opacity;

varying vec3 vWorldDirection;

void main() {

	vec4 texColor = textureCube( tCube, vec3( tFlip * vWorldDirection.x, vWorldDirection.yz ) );

	gl_FragColor = mapTexelToLinear( texColor );
	gl_FragColor.a *= opacity;

	#include <tonemapping_fragment>
	#include <encodings_fragment>

}
`,cube_vert:`
varying vec3 vWorldDirection;

#include <common>

void main() {

	vWorldDirection = transformDirection( position, modelMatrix );

	#include <begin_vertex>
	#include <project_vertex>

	gl_Position.z = gl_Position.w; // set z to camera.far

}
`,depth_frag:`
#if DEPTH_PACKING == 3200

	uniform float opacity;

#endif

#include <common>
#include <packing>
#include <uv_pars_fragment>
#include <map_pars_fragment>
#include <alphamap_pars_fragment>
#include <logdepthbuf_pars_fragment>
#include <clipping_planes_pars_fragment>

void main() {

	#include <clipping_planes_fragment>

	vec4 diffuseColor = vec4( 1.0 );

	#if DEPTH_PACKING == 3200

		diffuseColor.a = opacity;

	#endif

	#include <map_fragment>
	#include <alphamap_fragment>
	#include <alphatest_fragment>

	#include <logdepthbuf_fragment>

	#if DEPTH_PACKING == 3200

		gl_FragColor = vec4( vec3( 1.0 - gl_FragCoord.z ), opacity );

	#elif DEPTH_PACKING == 3201

		gl_FragColor = packDepthToRGBA( gl_FragCoord.z );

	#endif

}
`,depth_vert:`
#include <common>
#include <uv_pars_vertex>
#include <displacementmap_pars_vertex>
#include <morphtarget_pars_vertex>
#include <skinning_pars_vertex>
#include <logdepthbuf_pars_vertex>
#include <clipping_planes_pars_vertex>

void main() {

	#include <uv_vertex>

	#include <skinbase_vertex>

	#ifdef USE_DISPLACEMENTMAP

		#include <beginnormal_vertex>
		#include <morphnormal_vertex>
		#include <skinnormal_vertex>

	#endif

	#include <begin_vertex>
	#include <morphtarget_vertex>
	#include <skinning_vertex>
	#include <displacementmap_vertex>
	#include <project_vertex>
	#include <logdepthbuf_vertex>
	#include <clipping_planes_vertex>

}
`,distanceRGBA_frag:`
#define DISTANCE

uniform vec3 referencePosition;
uniform float nearDistance;
uniform float farDistance;
varying vec3 vWorldPosition;

#include <common>
#include <packing>
#include <uv_pars_fragment>
#include <map_pars_fragment>
#include <alphamap_pars_fragment>
#include <clipping_planes_pars_fragment>

void main () {

	#include <clipping_planes_fragment>

	vec4 diffuseColor = vec4( 1.0 );

	#include <map_fragment>
	#include <alphamap_fragment>
	#include <alphatest_fragment>

	float dist = length( vWorldPosition - referencePosition );
	dist = ( dist - nearDistance ) / ( farDistance - nearDistance );
	dist = saturate( dist ); // clamp to [ 0, 1 ]

	gl_FragColor = packDepthToRGBA( dist );

}
`,distanceRGBA_vert:`
#define DISTANCE

varying vec3 vWorldPosition;

#include <common>
#include <uv_pars_vertex>
#include <displacementmap_pars_vertex>
#include <morphtarget_pars_vertex>
#include <skinning_pars_vertex>
#include <clipping_planes_pars_vertex>

void main() {

	#include <uv_vertex>

	#include <skinbase_vertex>

	#ifdef USE_DISPLACEMENTMAP

		#include <beginnormal_vertex>
		#include <morphnormal_vertex>
		#include <skinnormal_vertex>

	#endif

	#include <begin_vertex>
	#include <morphtarget_vertex>
	#include <skinning_vertex>
	#include <displacementmap_vertex>
	#include <project_vertex>
	#include <worldpos_vertex>
	#include <clipping_planes_vertex>

	vWorldPosition = worldPosition.xyz;

}
`,equirect_frag:`
uniform sampler2D tEquirect;

varying vec3 vWorldDirection;

#include <common>

void main() {

	vec3 direction = normalize( vWorldDirection );

	vec2 sampleUV;

	sampleUV.y = asin( clamp( direction.y, - 1.0, 1.0 ) ) * RECIPROCAL_PI + 0.5;

	sampleUV.x = atan( direction.z, direction.x ) * RECIPROCAL_PI2 + 0.5;

	vec4 texColor = texture2D( tEquirect, sampleUV );

	gl_FragColor = mapTexelToLinear( texColor );

	#include <tonemapping_fragment>
	#include <encodings_fragment>

}
`,equirect_vert:`
varying vec3 vWorldDirection;

#include <common>

void main() {

	vWorldDirection = transformDirection( position, modelMatrix );

	#include <begin_vertex>
	#include <project_vertex>

}
`,linedashed_frag:`
uniform vec3 diffuse;
uniform float opacity;

uniform float dashSize;
uniform float totalSize;

varying float vLineDistance;

#include <common>
#include <color_pars_fragment>
#include <fog_pars_fragment>
#include <logdepthbuf_pars_fragment>
#include <clipping_planes_pars_fragment>

void main() {

	#include <clipping_planes_fragment>

	if ( mod( vLineDistance, totalSize ) > dashSize ) {

		discard;

	}

	vec3 outgoingLight = vec3( 0.0 );
	vec4 diffuseColor = vec4( diffuse, opacity );

	#include <logdepthbuf_fragment>
	#include <color_fragment>

	outgoingLight = diffuseColor.rgb; // simple shader

	gl_FragColor = vec4( outgoingLight, diffuseColor.a );

	#include <premultiplied_alpha_fragment>
	#include <tonemapping_fragment>
	#include <encodings_fragment>
	#include <fog_fragment>

}
`,linedashed_vert:`
uniform float scale;
attribute float lineDistance;

varying float vLineDistance;

#include <common>
#include <color_pars_vertex>
#include <fog_pars_vertex>
#include <logdepthbuf_pars_vertex>
#include <clipping_planes_pars_vertex>

void main() {

	#include <color_vertex>

	vLineDistance = scale * lineDistance;

	vec4 mvPosition = modelViewMatrix * vec4( position, 1.0 );
	gl_Position = projectionMatrix * mvPosition;

	#include <logdepthbuf_vertex>
	#include <clipping_planes_vertex>
	#include <fog_vertex>

}
`,meshbasic_frag:`
uniform vec3 diffuse;
uniform float opacity;

#ifndef FLAT_SHADED

	varying vec3 vNormal;

#endif

#include <common>
#include <color_pars_fragment>
#include <uv_pars_fragment>
#include <uv2_pars_fragment>
#include <map_pars_fragment>
#include <alphamap_pars_fragment>
#include <aomap_pars_fragment>
#include <lightmap_pars_fragment>
#include <envmap_pars_fragment>
#include <fog_pars_fragment>
#include <specularmap_pars_fragment>
#include <logdepthbuf_pars_fragment>
#include <clipping_planes_pars_fragment>

void main() {

	#include <clipping_planes_fragment>

	vec4 diffuseColor = vec4( diffuse, opacity );

	#include <logdepthbuf_fragment>
	#include <map_fragment>
	#include <color_fragment>
	#include <alphamap_fragment>
	#include <alphatest_fragment>
	#include <specularmap_fragment>

	ReflectedLight reflectedLight = ReflectedLight( vec3( 0.0 ), vec3( 0.0 ), vec3( 0.0 ), vec3( 0.0 ) );

	// accumulation (baked indirect lighting only)
	#ifdef USE_LIGHTMAP

		reflectedLight.indirectDiffuse += texture2D( lightMap, vUv2 ).xyz * lightMapIntensity;

	#else

		reflectedLight.indirectDiffuse += vec3( 1.0 );

	#endif

	// modulation
	#include <aomap_fragment>

	reflectedLight.indirectDiffuse *= diffuseColor.rgb;

	vec3 outgoingLight = reflectedLight.indirectDiffuse;

	#include <envmap_fragment>

	gl_FragColor = vec4( outgoingLight, diffuseColor.a );

	#include <premultiplied_alpha_fragment>
	#include <tonemapping_fragment>
	#include <encodings_fragment>
	#include <fog_fragment>

}
`,meshbasic_vert:`
#include <common>
#include <uv_pars_vertex>
#include <uv2_pars_vertex>
#include <envmap_pars_vertex>
#include <color_pars_vertex>
#include <fog_pars_vertex>
#include <morphtarget_pars_vertex>
#include <skinning_pars_vertex>
#include <logdepthbuf_pars_vertex>
#include <clipping_planes_pars_vertex>

void main() {

	#include <uv_vertex>
	#include <uv2_vertex>
	#include <color_vertex>
	#include <skinbase_vertex>

	#ifdef USE_ENVMAP

	#include <beginnormal_vertex>
	#include <morphnormal_vertex>
	#include <skinnormal_vertex>
	#include <defaultnormal_vertex>

	#endif

	#include <begin_vertex>
	#include <morphtarget_vertex>
	#include <skinning_vertex>
	#include <project_vertex>
	#include <logdepthbuf_vertex>

	#include <worldpos_vertex>
	#include <clipping_planes_vertex>
	#include <envmap_vertex>
	#include <fog_vertex>

}
`,meshlambert_frag:`
uniform vec3 diffuse;
uniform vec3 emissive;
uniform float opacity;

varying vec3 vLightFront;

#ifdef DOUBLE_SIDED

	varying vec3 vLightBack;

#endif

#include <common>
#include <packing>
#include <dithering_pars_fragment>
#include <color_pars_fragment>
#include <uv_pars_fragment>
#include <uv2_pars_fragment>
#include <map_pars_fragment>
#include <alphamap_pars_fragment>
#include <aomap_pars_fragment>
#include <lightmap_pars_fragment>
#include <emissivemap_pars_fragment>
#include <envmap_pars_fragment>
#include <bsdfs>
#include <lights_pars_begin>
#include <fog_pars_fragment>
#include <shadowmap_pars_fragment>
#include <shadowmask_pars_fragment>
#include <specularmap_pars_fragment>
#include <logdepthbuf_pars_fragment>
#include <clipping_planes_pars_fragment>

void main() {

	#include <clipping_planes_fragment>

	vec4 diffuseColor = vec4( diffuse, opacity );
	ReflectedLight reflectedLight = ReflectedLight( vec3( 0.0 ), vec3( 0.0 ), vec3( 0.0 ), vec3( 0.0 ) );
	vec3 totalEmissiveRadiance = emissive;

	#include <logdepthbuf_fragment>
	#include <map_fragment>
	#include <color_fragment>
	#include <alphamap_fragment>
	#include <alphatest_fragment>
	#include <specularmap_fragment>
	#include <emissivemap_fragment>

	// accumulation
	reflectedLight.indirectDiffuse = getAmbientLightIrradiance( ambientLightColor );

	#include <lightmap_fragment>

	reflectedLight.indirectDiffuse *= BRDF_Diffuse_Lambert( diffuseColor.rgb );

	#ifdef DOUBLE_SIDED

		reflectedLight.directDiffuse = ( gl_FrontFacing ) ? vLightFront : vLightBack;

	#else

		reflectedLight.directDiffuse = vLightFront;

	#endif

	reflectedLight.directDiffuse *= BRDF_Diffuse_Lambert( diffuseColor.rgb ) * getShadowMask();

	// modulation
	#include <aomap_fragment>

	vec3 outgoingLight = reflectedLight.directDiffuse + reflectedLight.indirectDiffuse + totalEmissiveRadiance;

	#include <envmap_fragment>

	gl_FragColor = vec4( outgoingLight, diffuseColor.a );

	#include <tonemapping_fragment>
	#include <encodings_fragment>
	#include <fog_fragment>
	#include <premultiplied_alpha_fragment>
	#include <dithering_fragment>

}
`,meshlambert_vert:`
#define LAMBERT

varying vec3 vLightFront;

#ifdef DOUBLE_SIDED

	varying vec3 vLightBack;

#endif

#include <common>
#include <uv_pars_vertex>
#include <uv2_pars_vertex>
#include <envmap_pars_vertex>
#include <bsdfs>
#include <lights_pars_begin>
#include <color_pars_vertex>
#include <fog_pars_vertex>
#include <morphtarget_pars_vertex>
#include <skinning_pars_vertex>
#include <shadowmap_pars_vertex>
#include <logdepthbuf_pars_vertex>
#include <clipping_planes_pars_vertex>

void main() {

	#include <uv_vertex>
	#include <uv2_vertex>
	#include <color_vertex>

	#include <beginnormal_vertex>
	#include <morphnormal_vertex>
	#include <skinbase_vertex>
	#include <skinnormal_vertex>
	#include <defaultnormal_vertex>

	#include <begin_vertex>
	#include <morphtarget_vertex>
	#include <skinning_vertex>
	#include <project_vertex>
	#include <logdepthbuf_vertex>
	#include <clipping_planes_vertex>

	#include <worldpos_vertex>
	#include <envmap_vertex>
	#include <lights_lambert_vertex>
	#include <shadowmap_vertex>
	#include <fog_vertex>

}
`,meshmatcap_frag:`
#define MATCAP

uniform vec3 diffuse;
uniform float opacity;
uniform sampler2D matcap;

varying vec3 vViewPosition;

#ifndef FLAT_SHADED

	varying vec3 vNormal;

#endif

#include <common>
#include <uv_pars_fragment>
#include <map_pars_fragment>
#include <alphamap_pars_fragment>

#include <fog_pars_fragment>
#include <bumpmap_pars_fragment>
#include <normalmap_pars_fragment>
#include <logdepthbuf_pars_fragment>
#include <clipping_planes_pars_fragment>

void main() {

	#include <clipping_planes_fragment>

	vec4 diffuseColor = vec4( diffuse, opacity );

	#include <logdepthbuf_fragment>
	#include <map_fragment>
	#include <alphamap_fragment>
	#include <alphatest_fragment>
	#include <normal_fragment_begin>
	#include <normal_fragment_maps>

	vec3 viewDir = normalize( vViewPosition );
	vec3 x = normalize( vec3( viewDir.z, 0.0, - viewDir.x ) );
	vec3 y = cross( viewDir, x );
	vec2 uv = vec2( dot( x, normal ), dot( y, normal ) ) * 0.495 + 0.5; // 0.495 to remove artifacts caused by undersized matcap disks

	#ifdef USE_MATCAP

		vec4 matcapColor = texture2D( matcap, uv );
		matcapColor = matcapTexelToLinear( matcapColor );

	#else

		vec4 matcapColor = vec4( 1.0 );

	#endif

	vec3 outgoingLight = diffuseColor.rgb * matcapColor.rgb;

	gl_FragColor = vec4( outgoingLight, diffuseColor.a );

	#include <premultiplied_alpha_fragment>
	#include <tonemapping_fragment>
	#include <encodings_fragment>
	#include <fog_fragment>

}
`,meshmatcap_vert:`
#define MATCAP

varying vec3 vViewPosition;

#ifndef FLAT_SHADED

	varying vec3 vNormal;

#endif

#include <common>
#include <uv_pars_vertex>
#include <displacementmap_pars_vertex>
#include <fog_pars_vertex>
#include <morphtarget_pars_vertex>
#include <skinning_pars_vertex>

#include <logdepthbuf_pars_vertex>
#include <clipping_planes_pars_vertex>

void main() {

	#include <uv_vertex>

	#include <beginnormal_vertex>
	#include <morphnormal_vertex>
	#include <skinbase_vertex>
	#include <skinnormal_vertex>
	#include <defaultnormal_vertex>

	#ifndef FLAT_SHADED // Normal computed with derivatives when FLAT_SHADED

		vNormal = normalize( transformedNormal );

	#endif

	#include <begin_vertex>
	#include <morphtarget_vertex>
	#include <skinning_vertex>
	#include <displacementmap_vertex>
	#include <project_vertex>

	#include <logdepthbuf_vertex>
	#include <clipping_planes_vertex>
	#include <fog_vertex>

	vViewPosition = - mvPosition.xyz;

}
`,meshphong_frag:`
#define PHONG

uniform vec3 diffuse;
uniform vec3 emissive;
uniform vec3 specular;
uniform float shininess;
uniform float opacity;

#include <common>
#include <packing>
#include <dithering_pars_fragment>
#include <color_pars_fragment>
#include <uv_pars_fragment>
#include <uv2_pars_fragment>
#include <map_pars_fragment>
#include <alphamap_pars_fragment>
#include <aomap_pars_fragment>
#include <lightmap_pars_fragment>
#include <emissivemap_pars_fragment>
#include <envmap_pars_fragment>
#include <gradientmap_pars_fragment>
#include <fog_pars_fragment>
#include <bsdfs>
#include <lights_pars_begin>
#include <lights_phong_pars_fragment>
#include <shadowmap_pars_fragment>
#include <bumpmap_pars_fragment>
#include <normalmap_pars_fragment>
#include <specularmap_pars_fragment>
#include <logdepthbuf_pars_fragment>
#include <clipping_planes_pars_fragment>

void main() {

	#include <clipping_planes_fragment>

	vec4 diffuseColor = vec4( diffuse, opacity );
	ReflectedLight reflectedLight = ReflectedLight( vec3( 0.0 ), vec3( 0.0 ), vec3( 0.0 ), vec3( 0.0 ) );
	vec3 totalEmissiveRadiance = emissive;

	#include <logdepthbuf_fragment>
	#include <map_fragment>
	#include <color_fragment>
	#include <alphamap_fragment>
	#include <alphatest_fragment>
	#include <specularmap_fragment>
	#include <normal_fragment_begin>
	#include <normal_fragment_maps>
	#include <emissivemap_fragment>

	// accumulation
	#include <lights_phong_fragment>
	#include <lights_fragment_begin>
	#include <lights_fragment_maps>
	#include <lights_fragment_end>

	// modulation
	#include <aomap_fragment>

	vec3 outgoingLight = reflectedLight.directDiffuse + reflectedLight.indirectDiffuse + reflectedLight.directSpecular + reflectedLight.indirectSpecular + totalEmissiveRadiance;

	#include <envmap_fragment>

	gl_FragColor = vec4( outgoingLight, diffuseColor.a );

	#include <tonemapping_fragment>
	#include <encodings_fragment>
	#include <fog_fragment>
	#include <premultiplied_alpha_fragment>
	#include <dithering_fragment>

}
`,meshphong_vert:`
#define PHONG

varying vec3 vViewPosition;

#ifndef FLAT_SHADED

	varying vec3 vNormal;

#endif

#include <common>
#include <uv_pars_vertex>
#include <uv2_pars_vertex>
#include <displacementmap_pars_vertex>
#include <envmap_pars_vertex>
#include <color_pars_vertex>
#include <fog_pars_vertex>
#include <morphtarget_pars_vertex>
#include <skinning_pars_vertex>
#include <shadowmap_pars_vertex>
#include <logdepthbuf_pars_vertex>
#include <clipping_planes_pars_vertex>

void main() {

	#include <uv_vertex>
	#include <uv2_vertex>
	#include <color_vertex>

	#include <beginnormal_vertex>
	#include <morphnormal_vertex>
	#include <skinbase_vertex>
	#include <skinnormal_vertex>
	#include <defaultnormal_vertex>

#ifndef FLAT_SHADED // Normal computed with derivatives when FLAT_SHADED

	vNormal = normalize( transformedNormal );

#endif

	#include <begin_vertex>
	#include <morphtarget_vertex>
	#include <skinning_vertex>
	#include <displacementmap_vertex>
	#include <project_vertex>
	#include <logdepthbuf_vertex>
	#include <clipping_planes_vertex>

	vViewPosition = - mvPosition.xyz;

	#include <worldpos_vertex>
	#include <envmap_vertex>
	#include <shadowmap_vertex>
	#include <fog_vertex>

}
`,meshphysical_frag:`
#define PHYSICAL

uniform vec3 diffuse;
uniform vec3 emissive;
uniform float roughness;
uniform float metalness;
uniform float opacity;

#ifndef STANDARD
	uniform float clearCoat;
	uniform float clearCoatRoughness;
#endif

varying vec3 vViewPosition;

#ifndef FLAT_SHADED

	varying vec3 vNormal;

#endif

#include <common>
#include <packing>
#include <dithering_pars_fragment>
#include <color_pars_fragment>
#include <uv_pars_fragment>
#include <uv2_pars_fragment>
#include <map_pars_fragment>
#include <alphamap_pars_fragment>
#include <aomap_pars_fragment>
#include <lightmap_pars_fragment>
#include <emissivemap_pars_fragment>
#include <bsdfs>
#include <cube_uv_reflection_fragment>
#include <envmap_pars_fragment>
#include <envmap_physical_pars_fragment>
#include <fog_pars_fragment>
#include <lights_pars_begin>
#include <lights_physical_pars_fragment>
#include <shadowmap_pars_fragment>
#include <bumpmap_pars_fragment>
#include <normalmap_pars_fragment>
#include <roughnessmap_pars_fragment>
#include <metalnessmap_pars_fragment>
#include <logdepthbuf_pars_fragment>
#include <clipping_planes_pars_fragment>

void main() {

	#include <clipping_planes_fragment>

	vec4 diffuseColor = vec4( diffuse, opacity );
	ReflectedLight reflectedLight = ReflectedLight( vec3( 0.0 ), vec3( 0.0 ), vec3( 0.0 ), vec3( 0.0 ) );
	vec3 totalEmissiveRadiance = emissive;

	#include <logdepthbuf_fragment>
	#include <map_fragment>
	#include <color_fragment>
	#include <alphamap_fragment>
	#include <alphatest_fragment>
	#include <roughnessmap_fragment>
	#include <metalnessmap_fragment>
	#include <normal_fragment_begin>
	#include <normal_fragment_maps>
	#include <emissivemap_fragment>

	// accumulation
	#include <lights_physical_fragment>
	#include <lights_fragment_begin>
	#include <lights_fragment_maps>
	#include <lights_fragment_end>

	// modulation
	#include <aomap_fragment>

	vec3 outgoingLight = reflectedLight.directDiffuse + reflectedLight.indirectDiffuse + reflectedLight.directSpecular + reflectedLight.indirectSpecular + totalEmissiveRadiance;

	gl_FragColor = vec4( outgoingLight, diffuseColor.a );

	#include <tonemapping_fragment>
	#include <encodings_fragment>
	#include <fog_fragment>
	#include <premultiplied_alpha_fragment>
	#include <dithering_fragment>

}
`,meshphysical_vert:`
#define PHYSICAL

varying vec3 vViewPosition;

#ifndef FLAT_SHADED

	varying vec3 vNormal;

#endif

#include <common>
#include <uv_pars_vertex>
#include <uv2_pars_vertex>
#include <displacementmap_pars_vertex>
#include <color_pars_vertex>
#include <fog_pars_vertex>
#include <morphtarget_pars_vertex>
#include <skinning_pars_vertex>
#include <shadowmap_pars_vertex>
#include <logdepthbuf_pars_vertex>
#include <clipping_planes_pars_vertex>

void main() {

	#include <uv_vertex>
	#include <uv2_vertex>
	#include <color_vertex>

	#include <beginnormal_vertex>
	#include <morphnormal_vertex>
	#include <skinbase_vertex>
	#include <skinnormal_vertex>
	#include <defaultnormal_vertex>

#ifndef FLAT_SHADED // Normal computed with derivatives when FLAT_SHADED

	vNormal = normalize( transformedNormal );

#endif

	#include <begin_vertex>
	#include <morphtarget_vertex>
	#include <skinning_vertex>
	#include <displacementmap_vertex>
	#include <project_vertex>
	#include <logdepthbuf_vertex>
	#include <clipping_planes_vertex>

	vViewPosition = - mvPosition.xyz;

	#include <worldpos_vertex>
	#include <shadowmap_vertex>
	#include <fog_vertex>

}
`,normal_frag:`
#define NORMAL

uniform float opacity;

#if defined( FLAT_SHADED ) || defined( USE_BUMPMAP ) || ( defined( USE_NORMALMAP ) && ! defined( OBJECTSPACE_NORMALMAP ) )

	varying vec3 vViewPosition;

#endif

#ifndef FLAT_SHADED

	varying vec3 vNormal;

#endif

#include <packing>
#include <uv_pars_fragment>
#include <bumpmap_pars_fragment>
#include <normalmap_pars_fragment>
#include <logdepthbuf_pars_fragment>

void main() {

	#include <logdepthbuf_fragment>
	#include <normal_fragment_begin>
	#include <normal_fragment_maps>

	gl_FragColor = vec4( packNormalToRGB( normal ), opacity );

}
`,normal_vert:`
#define NORMAL

#if defined( FLAT_SHADED ) || defined( USE_BUMPMAP ) || ( defined( USE_NORMALMAP ) && ! defined( OBJECTSPACE_NORMALMAP ) )

	varying vec3 vViewPosition;

#endif

#ifndef FLAT_SHADED

	varying vec3 vNormal;

#endif

#include <uv_pars_vertex>
#include <displacementmap_pars_vertex>
#include <morphtarget_pars_vertex>
#include <skinning_pars_vertex>
#include <logdepthbuf_pars_vertex>

void main() {

	#include <uv_vertex>

	#include <beginnormal_vertex>
	#include <morphnormal_vertex>
	#include <skinbase_vertex>
	#include <skinnormal_vertex>
	#include <defaultnormal_vertex>

#ifndef FLAT_SHADED // Normal computed with derivatives when FLAT_SHADED

	vNormal = normalize( transformedNormal );

#endif

	#include <begin_vertex>
	#include <morphtarget_vertex>
	#include <skinning_vertex>
	#include <displacementmap_vertex>
	#include <project_vertex>
	#include <logdepthbuf_vertex>

#if defined( FLAT_SHADED ) || defined( USE_BUMPMAP ) || ( defined( USE_NORMALMAP ) && ! defined( OBJECTSPACE_NORMALMAP ) )

	vViewPosition = - mvPosition.xyz;

#endif

}
`,points_frag:`
uniform vec3 diffuse;
uniform float opacity;

#include <common>
#include <color_pars_fragment>
#include <map_particle_pars_fragment>
#include <fog_pars_fragment>
#include <logdepthbuf_pars_fragment>
#include <clipping_planes_pars_fragment>

void main() {

	#include <clipping_planes_fragment>

	vec3 outgoingLight = vec3( 0.0 );
	vec4 diffuseColor = vec4( diffuse, opacity );

	#include <logdepthbuf_fragment>
	#include <map_particle_fragment>
	#include <color_fragment>
	#include <alphatest_fragment>

	outgoingLight = diffuseColor.rgb;

	gl_FragColor = vec4( outgoingLight, diffuseColor.a );

	#include <premultiplied_alpha_fragment>
	#include <tonemapping_fragment>
	#include <encodings_fragment>
	#include <fog_fragment>

}
`,points_vert:`
uniform float size;
uniform float scale;

#include <common>
#include <color_pars_vertex>
#include <fog_pars_vertex>
#include <morphtarget_pars_vertex>
#include <logdepthbuf_pars_vertex>
#include <clipping_planes_pars_vertex>

void main() {

	#include <color_vertex>
	#include <begin_vertex>
	#include <morphtarget_vertex>
	#include <project_vertex>

	gl_PointSize = size;

	#ifdef USE_SIZEATTENUATION

		bool isPerspective = ( projectionMatrix[ 2 ][ 3 ] == - 1.0 );

		if ( isPerspective ) gl_PointSize *= ( scale / - mvPosition.z );

	#endif

	#include <logdepthbuf_vertex>
	#include <clipping_planes_vertex>
	#include <worldpos_vertex>
	#include <fog_vertex>

}
`,shadow_frag:`
uniform vec3 color;
uniform float opacity;

#include <common>
#include <packing>
#include <fog_pars_fragment>
#include <bsdfs>
#include <lights_pars_begin>
#include <shadowmap_pars_fragment>
#include <shadowmask_pars_fragment>

void main() {

	gl_FragColor = vec4( color, opacity * ( 1.0 - getShadowMask() ) );

	#include <fog_fragment>

}
`,shadow_vert:`
#include <fog_pars_vertex>
#include <shadowmap_pars_vertex>

void main() {

	#include <begin_vertex>
	#include <project_vertex>
	#include <worldpos_vertex>
	#include <shadowmap_vertex>
	#include <fog_vertex>

}
`,sprite_frag:`
uniform vec3 diffuse;
uniform float opacity;

#include <common>
#include <uv_pars_fragment>
#include <map_pars_fragment>
#include <fog_pars_fragment>
#include <logdepthbuf_pars_fragment>
#include <clipping_planes_pars_fragment>

void main() {

	#include <clipping_planes_fragment>

	vec3 outgoingLight = vec3( 0.0 );
	vec4 diffuseColor = vec4( diffuse, opacity );

	#include <logdepthbuf_fragment>
	#include <map_fragment>
	#include <alphatest_fragment>

	outgoingLight = diffuseColor.rgb;

	gl_FragColor = vec4( outgoingLight, diffuseColor.a );

	#include <tonemapping_fragment>
	#include <encodings_fragment>
	#include <fog_fragment>

}
`,sprite_vert:`
uniform float rotation;
uniform vec2 center;

#include <common>
#include <uv_pars_vertex>
#include <fog_pars_vertex>
#include <logdepthbuf_pars_vertex>
#include <clipping_planes_pars_vertex>

void main() {

	#include <uv_vertex>

	vec4 mvPosition = modelViewMatrix * vec4( 0.0, 0.0, 0.0, 1.0 );

	vec2 scale;
	scale.x = length( vec3( modelMatrix[ 0 ].x, modelMatrix[ 0 ].y, modelMatrix[ 0 ].z ) );
	scale.y = length( vec3( modelMatrix[ 1 ].x, modelMatrix[ 1 ].y, modelMatrix[ 1 ].z ) );

	#ifndef USE_SIZEATTENUATION

		bool isPerspective = ( projectionMatrix[ 2 ][ 3 ] == - 1.0 );

		if ( isPerspective ) scale *= - mvPosition.z;

	#endif

	vec2 alignedPosition = ( position.xy - ( center - vec2( 0.5 ) ) ) * scale;

	vec2 rotatedPosition;
	rotatedPosition.x = cos( rotation ) * alignedPosition.x - sin( rotation ) * alignedPosition.y;
	rotatedPosition.y = sin( rotation ) * alignedPosition.x + cos( rotation ) * alignedPosition.y;

	mvPosition.xy += rotatedPosition;

	gl_Position = projectionMatrix * mvPosition;

	#include <logdepthbuf_vertex>
	#include <clipping_planes_vertex>
	#include <fog_vertex>

}
`},Z={common:{diffuse:{value:new V(15658734)},opacity:{value:1},map:{value:null},uvTransform:{value:new k},alphaMap:{value:null}},specularmap:{specularMap:{value:null}},envmap:{envMap:{value:null},flipEnvMap:{value:-1},reflectivity:{value:1},refractionRatio:{value:.98},maxMipLevel:{value:0}},aomap:{aoMap:{value:null},aoMapIntensity:{value:1}},lightmap:{lightMap:{value:null},lightMapIntensity:{value:1}},emissivemap:{emissiveMap:{value:null}},bumpmap:{bumpMap:{value:null},bumpScale:{value:1}},normalmap:{normalMap:{value:null},normalScale:{value:new T(1,1)}},displacementmap:{displacementMap:{value:null},displacementScale:{value:1},displacementBias:{value:0}},roughnessmap:{roughnessMap:{value:null}},metalnessmap:{metalnessMap:{value:null}},gradientmap:{gradientMap:{value:null}},fog:{fogDensity:{value:25e-5},fogNear:{value:1},fogFar:{value:2e3},fogColor:{value:new V(16777215)}},lights:{ambientLightColor:{value:[]},directionalLights:{value:[],properties:{direction:{},color:{},shadow:{},shadowBias:{},shadowRadius:{},shadowMapSize:{}}},directionalShadowMap:{value:[]},directionalShadowMatrix:{value:[]},spotLights:{value:[],properties:{color:{},position:{},direction:{},distance:{},coneCos:{},penumbraCos:{},decay:{},shadow:{},shadowBias:{},shadowRadius:{},shadowMapSize:{}}},spotShadowMap:{value:[]},spotShadowMatrix:{value:[]},pointLights:{value:[],properties:{color:{},position:{},decay:{},distance:{},shadow:{},shadowBias:{},shadowRadius:{},shadowMapSize:{},shadowCameraNear:{},shadowCameraFar:{}}},pointShadowMap:{value:[]},pointShadowMatrix:{value:[]},hemisphereLights:{value:[],properties:{direction:{},skyColor:{},groundColor:{}}},rectAreaLights:{value:[],properties:{color:{},position:{},width:{},height:{}}}},points:{diffuse:{value:new V(15658734)},opacity:{value:1},size:{value:1},scale:{value:1},map:{value:null},uvTransform:{value:new k}},sprite:{diffuse:{value:new V(15658734)},opacity:{value:1},center:{value:new T(.5,.5)},rotation:{value:0},map:{value:null},uvTransform:{value:new k}}},ke={basic:{uniforms:Ce([Z.common,Z.specularmap,Z.envmap,Z.aomap,Z.lightmap,Z.fog]),vertexShader:X.meshbasic_vert,fragmentShader:X.meshbasic_frag},lambert:{uniforms:Ce([Z.common,Z.specularmap,Z.envmap,Z.aomap,Z.lightmap,Z.emissivemap,Z.fog,Z.lights,{emissive:{value:new V(0)}}]),vertexShader:X.meshlambert_vert,fragmentShader:X.meshlambert_frag},phong:{uniforms:Ce([Z.common,Z.specularmap,Z.envmap,Z.aomap,Z.lightmap,Z.emissivemap,Z.bumpmap,Z.normalmap,Z.displacementmap,Z.gradientmap,Z.fog,Z.lights,{emissive:{value:new V(0)},specular:{value:new V(1118481)},shininess:{value:30}}]),vertexShader:X.meshphong_vert,fragmentShader:X.meshphong_frag},standard:{uniforms:Ce([Z.common,Z.envmap,Z.aomap,Z.lightmap,Z.emissivemap,Z.bumpmap,Z.normalmap,Z.displacementmap,Z.roughnessmap,Z.metalnessmap,Z.fog,Z.lights,{emissive:{value:new V(0)},roughness:{value:.5},metalness:{value:.5},envMapIntensity:{value:1}}]),vertexShader:X.meshphysical_vert,fragmentShader:X.meshphysical_frag},matcap:{uniforms:Ce([Z.common,Z.bumpmap,Z.normalmap,Z.displacementmap,Z.fog,{matcap:{value:null}}]),vertexShader:X.meshmatcap_vert,fragmentShader:X.meshmatcap_frag},points:{uniforms:Ce([Z.points,Z.fog]),vertexShader:X.points_vert,fragmentShader:X.points_frag},dashed:{uniforms:Ce([Z.common,Z.fog,{scale:{value:1},dashSize:{value:1},totalSize:{value:2}}]),vertexShader:X.linedashed_vert,fragmentShader:X.linedashed_frag},depth:{uniforms:Ce([Z.common,Z.displacementmap]),vertexShader:X.depth_vert,fragmentShader:X.depth_frag},normal:{uniforms:Ce([Z.common,Z.bumpmap,Z.normalmap,Z.displacementmap,{opacity:{value:1}}]),vertexShader:X.normal_vert,fragmentShader:X.normal_frag},sprite:{uniforms:Ce([Z.sprite,Z.fog]),vertexShader:X.sprite_vert,fragmentShader:X.sprite_frag},background:{uniforms:{uvTransform:{value:new k},t2D:{value:null}},vertexShader:X.background_vert,fragmentShader:X.background_frag},cube:{uniforms:{tCube:{value:null},tFlip:{value:-1},opacity:{value:1}},vertexShader:X.cube_vert,fragmentShader:X.cube_frag},equirect:{uniforms:{tEquirect:{value:null}},vertexShader:X.equirect_vert,fragmentShader:X.equirect_frag},distanceRGBA:{uniforms:Ce([Z.common,Z.displacementmap,{referencePosition:{value:new O},nearDistance:{value:1},farDistance:{value:1e3}}]),vertexShader:X.distanceRGBA_vert,fragmentShader:X.distanceRGBA_frag},shadow:{uniforms:Ce([Z.lights,Z.fog,{color:{value:new V(0)},opacity:{value:1}}]),vertexShader:X.shadow_vert,fragmentShader:X.shadow_frag}};ke.physical={uniforms:Ce([ke.standard.uniforms,{clearCoat:{value:0},clearCoatRoughness:{value:0}}]),vertexShader:X.meshphysical_vert,fragmentShader:X.meshphysical_frag};function Ae(){var e=null,t=!1,n=null;function r(i,a){t!==!1&&(n(i,a),e.requestAnimationFrame(r))}return{start:function(){t!==!0&&n!==null&&(e.requestAnimationFrame(r),t=!0)},stop:function(){t=!1},setAnimationLoop:function(e){n=e},setContext:function(t){e=t}}}function je(e){var t=new WeakMap;function n(t,n){var r=t.array,i=t.dynamic?e.DYNAMIC_DRAW:e.STATIC_DRAW,a=e.createBuffer();e.bindBuffer(n,a),e.bufferData(n,r,i),t.onUploadCallback();var o=e.FLOAT;return r instanceof Float32Array?o=e.FLOAT:r instanceof Float64Array?console.warn(`THREE.WebGLAttributes: Unsupported data buffer format: Float64Array.`):r instanceof Uint16Array?o=e.UNSIGNED_SHORT:r instanceof Int16Array?o=e.SHORT:r instanceof Uint32Array?o=e.UNSIGNED_INT:r instanceof Int32Array?o=e.INT:r instanceof Int8Array?o=e.BYTE:r instanceof Uint8Array&&(o=e.UNSIGNED_BYTE),{buffer:a,type:o,bytesPerElement:r.BYTES_PER_ELEMENT,version:t.version}}function r(t,n,r){var i=n.array,a=n.updateRange;e.bindBuffer(r,t),n.dynamic===!1?e.bufferData(r,i,e.STATIC_DRAW):a.count===-1?e.bufferSubData(r,0,i):a.count===0?console.error(`THREE.WebGLObjects.updateBuffer: dynamic THREE.BufferAttribute marked as needsUpdate but updateRange.count is 0, ensure you are using set methods or updating manually.`):(e.bufferSubData(r,a.offset*i.BYTES_PER_ELEMENT,i.subarray(a.offset,a.offset+a.count)),a.count=-1)}function i(e){return e.isInterleavedBufferAttribute&&(e=e.data),t.get(e)}function a(n){n.isInterleavedBufferAttribute&&(n=n.data);var r=t.get(n);r&&(e.deleteBuffer(r.buffer),t.delete(n))}function o(e,i){e.isInterleavedBufferAttribute&&(e=e.data);var a=t.get(e);a===void 0?t.set(e,n(e,i)):a.version<e.version&&(r(a.buffer,e,i),a.version=e.version)}return{get:i,remove:a,update:o}}function Me(e,t,n,r,i,a){ve.call(this),this.type=`BoxGeometry`,this.parameters={width:e,height:t,depth:n,widthSegments:r,heightSegments:i,depthSegments:a},this.fromBufferGeometry(new Ne(e,t,n,r,i,a)),this.mergeVertices()}Me.prototype=Object.create(ve.prototype),Me.prototype.constructor=Me;function Ne(e,t,n,r,i,a){pe.call(this),this.type=`BoxBufferGeometry`,this.parameters={width:e,height:t,depth:n,widthSegments:r,heightSegments:i,depthSegments:a};var o=this;e||=1,t||=1,n||=1,r=Math.floor(r)||1,i=Math.floor(i)||1,a=Math.floor(a)||1;var s=[],c=[],l=[],u=[],d=0,f=0;p(`z`,`y`,`x`,-1,-1,n,t,e,a,i,0),p(`z`,`y`,`x`,1,-1,n,t,-e,a,i,1),p(`x`,`z`,`y`,1,1,e,n,t,r,a,2),p(`x`,`z`,`y`,1,-1,e,n,-t,r,a,3),p(`x`,`y`,`z`,1,-1,e,t,n,r,i,4),p(`x`,`y`,`z`,-1,-1,e,t,-n,r,i,5),this.setIndex(s),this.addAttribute(`position`,new Y(c,3)),this.addAttribute(`normal`,new Y(l,3)),this.addAttribute(`uv`,new Y(u,2));function p(e,t,n,r,i,a,p,m,h,g,_){var v=a/h,y=p/g,b=a/2,x=p/2,S=m/2,C=h+1,w=g+1,T=0,E=0,D,k,A=new O;for(k=0;k<w;k++){var j=k*y-x;for(D=0;D<C;D++)A[e]=(D*v-b)*r,A[t]=j*i,A[n]=S,c.push(A.x,A.y,A.z),A[e]=0,A[t]=0,A[n]=m>0?1:-1,l.push(A.x,A.y,A.z),u.push(D/h),u.push(1-k/g),T+=1}for(k=0;k<g;k++)for(D=0;D<h;D++){var M=d+D+C*k,N=d+D+C*(k+1),P=d+(D+1)+C*(k+1),F=d+(D+1)+C*k;s.push(M,N,F),s.push(N,P,F),E+=6}o.addGroup(f,E,_),f+=E,d+=T}}Ne.prototype=Object.create(pe.prototype),Ne.prototype.constructor=Ne;function Pe(e,t,n,r){var i=new V(0),a=0,o,s,c=null,l=0;function u(t,r,u,f){var p=r.background;if(p===null?(d(i,a),c=null,l=0):p&&p.isColor&&(d(p,1),f=!0,c=null,l=0),(e.autoClear||f)&&e.clear(e.autoClearColor,e.autoClearDepth,e.autoClearStencil),p&&(p.isCubeTexture||p.isWebGLRenderTargetCube)){s===void 0&&(s=new me(new Ne(1,1,1),new we({type:`BackgroundCubeMaterial`,uniforms:Se(ke.cube.uniforms),vertexShader:ke.cube.vertexShader,fragmentShader:ke.cube.fragmentShader,side:1,depthTest:!0,depthWrite:!1,fog:!1})),s.geometry.removeAttribute(`normal`),s.geometry.removeAttribute(`uv`),s.onBeforeRender=function(e,t,n){this.matrixWorld.copyPosition(n.matrixWorld)},Object.defineProperty(s.material,"map",{get:function(){return this.uniforms.tCube.value}}),n.update(s));var m=p.isWebGLRenderTargetCube?p.texture:p;s.material.uniforms.tCube.value=m,s.material.uniforms.tFlip.value=p.isWebGLRenderTargetCube?1:-1,(c!==p||l!==m.version)&&(s.material.needsUpdate=!0,c=p,l=m.version),t.unshift(s,s.geometry,s.material,0,0,null)}else p&&p.isTexture&&(o===void 0&&(o=new me(new be(2,2),new we({type:`BackgroundMaterial`,uniforms:Se(ke.background.uniforms),vertexShader:ke.background.vertexShader,fragmentShader:ke.background.fragmentShader,side:0,depthTest:!1,depthWrite:!1,fog:!1})),o.geometry.removeAttribute(`normal`),Object.defineProperty(o.material,"map",{get:function(){return this.uniforms.t2D.value}}),n.update(o)),o.material.uniforms.t2D.value=p,p.matrixAutoUpdate===!0&&p.updateMatrix(),o.material.uniforms.uvTransform.value.copy(p.matrix),(c!==p||l!==p.version)&&(o.material.needsUpdate=!0,c=p,l=p.version),t.unshift(o,o.geometry,o.material,0,0,null))}function d(e,n){t.buffers.color.setClear(e.r,e.g,e.b,n,r)}return{getClearColor:function(){return i},setClearColor:function(e,t){i.set(e),a=t===void 0?1:t,d(i,a)},getClearAlpha:function(){return a},setClearAlpha:function(e){a=e,d(i,a)},render:u}}function Fe(e,t,n,r){var i;function a(e){i=e}function o(t,r){e.drawArrays(i,t,r),n.update(r,i)}function s(a,o,s){var c;if(r.isWebGL2)c=e;else if(c=t.get(`ANGLE_instanced_arrays`),c===null){console.error(`THREE.WebGLBufferRenderer: using THREE.InstancedBufferGeometry but hardware does not support extension ANGLE_instanced_arrays.`);return}c[r.isWebGL2?`drawArraysInstanced`:`drawArraysInstancedANGLE`](i,o,s,a.maxInstancedCount),n.update(s,i,a.maxInstancedCount)}this.setMode=a,this.render=o,this.renderInstances=s}function Ie(e,t,n){var r;function i(){if(r!==void 0)return r;var n=t.get(`EXT_texture_filter_anisotropic`);return r=n===null?0:e.getParameter(n.MAX_TEXTURE_MAX_ANISOTROPY_EXT),r}function a(t){if(t===`highp`){if(e.getShaderPrecisionFormat(e.VERTEX_SHADER,e.HIGH_FLOAT).precision>0&&e.getShaderPrecisionFormat(e.FRAGMENT_SHADER,e.HIGH_FLOAT).precision>0)return`highp`;t=`mediump`}return t===`mediump`&&e.getShaderPrecisionFormat(e.VERTEX_SHADER,e.MEDIUM_FLOAT).precision>0&&e.getShaderPrecisionFormat(e.FRAGMENT_SHADER,e.MEDIUM_FLOAT).precision>0?`mediump`:`lowp`}var o=typeof WebGL2RenderingContext<`u`&&e instanceof WebGL2RenderingContext,s=n.precision===void 0?`highp`:n.precision,c=a(s);c!==s&&(console.warn(`THREE.WebGLRenderer:`,s,`not supported, using`,c,`instead.`),s=c);var l=n.logarithmicDepthBuffer===!0,u=e.getParameter(e.MAX_TEXTURE_IMAGE_UNITS),d=e.getParameter(e.MAX_VERTEX_TEXTURE_IMAGE_UNITS),f=e.getParameter(e.MAX_TEXTURE_SIZE),p=e.getParameter(e.MAX_CUBE_MAP_TEXTURE_SIZE),m=e.getParameter(e.MAX_VERTEX_ATTRIBS),h=e.getParameter(e.MAX_VERTEX_UNIFORM_VECTORS),g=e.getParameter(e.MAX_VARYING_VECTORS),_=e.getParameter(e.MAX_FRAGMENT_UNIFORM_VECTORS),v=d>0,y=o||!!t.get(`OES_texture_float`),b=v&&y,x=o?e.getParameter(e.MAX_SAMPLES):0;return{isWebGL2:o,getMaxAnisotropy:i,getMaxPrecision:a,precision:s,logarithmicDepthBuffer:l,maxTextures:u,maxVertexTextures:d,maxTextureSize:f,maxCubemapSize:p,maxAttributes:m,maxVertexUniforms:h,maxVaryings:g,maxFragmentUniforms:_,vertexTextures:v,floatFragmentTextures:y,floatVertexTextures:b,maxSamples:x}}function Le(){var e=this,t=null,n=0,r=!1,i=!1,a=new De,o=new k,s={value:null,needsUpdate:!1};this.uniform=s,this.numPlanes=0,this.numIntersection=0,this.init=function(e,i,a){var o=e.length!==0||i||n!==0||r;return r=i,t=l(e,a,0),n=e.length,o},this.beginShadows=function(){i=!0,l(null)},this.endShadows=function(){i=!1,c()},this.setState=function(e,a,o,u,d,f){if(!r||e===null||e.length===0||i&&!o)i?l(null):c();else{var p=i?0:n,m=p*4,h=d.clippingState||null;s.value=h,h=l(e,u,m,f);for(var g=0;g!==m;++g)h[g]=t[g];d.clippingState=h,this.numIntersection=a?this.numPlanes:0,this.numPlanes+=p}};function c(){s.value!==t&&(s.value=t,s.needsUpdate=n>0),e.numPlanes=n,e.numIntersection=0}function l(t,n,r,i){var c=t===null?0:t.length,l=null;if(c!==0){if(l=s.value,i!==!0||l===null){var u=r+c*4,d=n.matrixWorldInverse;o.getNormalMatrix(d),(l===null||l.length<u)&&(l=new Float32Array(u));for(var f=0,p=r;f!==c;++f,p+=4)a.copy(t[f]).applyMatrix4(d,o),a.normal.toArray(l,p),l[p+3]=a.constant}s.value=l,s.needsUpdate=!0}return e.numPlanes=c,l}}function Re(e){var t={};return{get:function(n){if(t[n]!==void 0)return t[n];var r;switch(n){case`WEBGL_depth_texture`:r=e.getExtension(`WEBGL_depth_texture`)||e.getExtension(`MOZ_WEBGL_depth_texture`)||e.getExtension(`WEBKIT_WEBGL_depth_texture`);break;case`EXT_texture_filter_anisotropic`:r=e.getExtension(`EXT_texture_filter_anisotropic`)||e.getExtension(`MOZ_EXT_texture_filter_anisotropic`)||e.getExtension(`WEBKIT_EXT_texture_filter_anisotropic`);break;case`WEBGL_compressed_texture_s3tc`:r=e.getExtension(`WEBGL_compressed_texture_s3tc`)||e.getExtension(`MOZ_WEBGL_compressed_texture_s3tc`)||e.getExtension(`WEBKIT_WEBGL_compressed_texture_s3tc`);break;case`WEBGL_compressed_texture_pvrtc`:r=e.getExtension(`WEBGL_compressed_texture_pvrtc`)||e.getExtension(`WEBKIT_WEBGL_compressed_texture_pvrtc`);break;default:r=e.getExtension(n)}return r===null&&console.warn(`THREE.WebGLRenderer: `+n+` extension not supported.`),t[n]=r,r}}}function ze(e,t,n){var r={},i={};function a(e){var o=e.target,s=r[o.id];for(var c in s.index!==null&&t.remove(s.index),s.attributes)t.remove(s.attributes[c]);o.removeEventListener(`dispose`,a),delete r[o.id];var l=i[s.id];l&&(t.remove(l),delete i[s.id]),n.memory.geometries--}function o(e,t){var i=r[t.id];return i||(t.addEventListener(`dispose`,a),t.isBufferGeometry?i=t:t.isGeometry&&(t._bufferGeometry===void 0&&(t._bufferGeometry=new pe().setFromObject(e)),i=t._bufferGeometry),r[t.id]=i,n.memory.geometries++,i)}function s(n){var r=n.index,i=n.attributes;for(var a in r!==null&&t.update(r,e.ELEMENT_ARRAY_BUFFER),i)t.update(i[a],e.ARRAY_BUFFER);var o=n.morphAttributes;for(var a in o)for(var s=o[a],c=0,l=s.length;c<l;c++)t.update(s[c],e.ARRAY_BUFFER)}function c(n){var r=i[n.id];if(r)return r;var a=[],o=n.index,s=n.attributes;if(o!==null)for(var c=o.array,l=0,u=c.length;l<u;l+=3){var d=c[l+0],f=c[l+1],p=c[l+2];a.push(d,f,f,p,p,d)}else for(var c=s.position.array,l=0,u=c.length/3-1;l<u;l+=3){var d=l+0,f=l+1,p=l+2;a.push(d,f,f,p,p,d)}return r=new(de(a)>65535?ce:J)(a,1),t.update(r,e.ELEMENT_ARRAY_BUFFER),i[n.id]=r,r}return{get:o,update:s,getWireframeAttribute:c}}function Be(e,t,n,r){var i;function a(e){i=e}var o,s;function c(e){o=e.type,s=e.bytesPerElement}function l(t,r){e.drawElements(i,r,o,t*s),n.update(r,i)}function u(a,c,l){var u;if(r.isWebGL2)u=e;else{var u=t.get(`ANGLE_instanced_arrays`);if(u===null){console.error(`THREE.WebGLIndexedBufferRenderer: using THREE.InstancedBufferGeometry but hardware does not support extension ANGLE_instanced_arrays.`);return}}u[r.isWebGL2?`drawElementsInstanced`:`drawElementsInstancedANGLE`](i,l,o,c*s,a.maxInstancedCount),n.update(l,i,a.maxInstancedCount)}this.setMode=a,this.setIndex=c,this.render=l,this.renderInstances=u}function Ve(e){var t={geometries:0,textures:0},n={frame:0,calls:0,triangles:0,points:0,lines:0};function r(t,r,i){switch(i||=1,n.calls++,r){case e.TRIANGLES:n.triangles+=t/3*i;break;case e.TRIANGLE_STRIP:case e.TRIANGLE_FAN:n.triangles+=i*(t-2);break;case e.LINES:n.lines+=t/2*i;break;case e.LINE_STRIP:n.lines+=i*(t-1);break;case e.LINE_LOOP:n.lines+=i*t;break;case e.POINTS:n.points+=i*t;break;default:console.error(`THREE.WebGLInfo: Unknown draw mode:`,r);break}}function i(){n.frame++,n.calls=0,n.triangles=0,n.points=0,n.lines=0}return{memory:t,render:n,programs:null,autoReset:!0,reset:i,update:r}}function He(e,t){return Math.abs(t[1])-Math.abs(e[1])}function Ue(e){var t={},n=new Float32Array(8);function r(r,i,a,o){var s=r.morphTargetInfluences,c=s.length,l=t[i.id];if(l===void 0){l=[];for(var u=0;u<c;u++)l[u]=[u,0];t[i.id]=l}for(var d=a.morphTargets&&i.morphAttributes.position,f=a.morphNormals&&i.morphAttributes.normal,u=0;u<c;u++){var p=l[u];p[1]!==0&&(d&&i.removeAttribute(`morphTarget`+u),f&&i.removeAttribute(`morphNormal`+u))}for(var u=0;u<c;u++){var p=l[u];p[0]=u,p[1]=s[u]}l.sort(He);for(var u=0;u<8;u++){var p=l[u];if(p){var m=p[0],h=p[1];if(h){d&&i.addAttribute(`morphTarget`+u,d[m]),f&&i.addAttribute(`morphNormal`+u,f[m]),n[u]=h;continue}}n[u]=0}o.getUniforms().setValue(e,`morphTargetInfluences`,n)}return{update:r}}function We(e,t){var n={};function r(r){var i=t.render.frame,a=r.geometry,o=e.get(r,a);return n[o.id]!==i&&(a.isGeometry&&o.updateFromObject(r),e.update(o),n[o.id]=i),o}function i(){n={}}return{update:r,dispose:i}}function Ge(e,t,n,r,i,a,o,s,c,l){e=e===void 0?[]:e,t=t===void 0?301:t,N.call(this,e,t,n,r,i,a,o,s,c,l),this.flipY=!1}Ge.prototype=Object.create(N.prototype),Ge.prototype.constructor=Ge,Ge.prototype.isCubeTexture=!0,Object.defineProperty(Ge.prototype,"images",{get:function(){return this.image},set:function(e){this.image=e}});function Ke(e,t,n,r){N.call(this,null),this.image={data:e,width:t,height:n,depth:r},this.magFilter=o,this.minFilter=o,this.generateMipmaps=!1,this.flipY=!1}Ke.prototype=Object.create(N.prototype),Ke.prototype.constructor=Ke,Ke.prototype.isDataTexture3D=!0;var qe=new N,Je=new Ke,Ye=new Ge;function Xe(){this.seq=[],this.map={}}var Ze=[],Qe=[],$e=new Float32Array(16),et=new Float32Array(9),tt=new Float32Array(4);function nt(e,t,n){var r=e[0];if(r<=0||r>0)return e;var i=t*n,a=Ze[i];if(a===void 0&&(a=new Float32Array(i),Ze[i]=a),t!==0){r.toArray(a,0);for(var o=1,s=0;o!==t;++o)s+=n,e[o].toArray(a,s)}return a}function Q(e,t){if(e.length!==t.length)return!1;for(var n=0,r=e.length;n<r;n++)if(e[n]!==t[n])return!1;return!0}function $(e,t){for(var n=0,r=t.length;n<r;n++)e[n]=t[n]}function rt(e,t){var n=Qe[t];n===void 0&&(n=new Int32Array(t),Qe[t]=n);for(var r=0;r!==t;++r)n[r]=e.allocTextureUnit();return n}function it(e,t){var n=this.cache;n[0]!==t&&(e.uniform1f(this.addr,t),n[0]=t)}function at(e,t){var n=this.cache;n[0]!==t&&(e.uniform1i(this.addr,t),n[0]=t)}function ot(e,t){var n=this.cache;if(t.x!==void 0)(n[0]!==t.x||n[1]!==t.y)&&(e.uniform2f(this.addr,t.x,t.y),n[0]=t.x,n[1]=t.y);else{if(Q(n,t))return;e.uniform2fv(this.addr,t),$(n,t)}}function st(e,t){var n=this.cache;if(t.x!==void 0)(n[0]!==t.x||n[1]!==t.y||n[2]!==t.z)&&(e.uniform3f(this.addr,t.x,t.y,t.z),n[0]=t.x,n[1]=t.y,n[2]=t.z);else if(t.r!==void 0)(n[0]!==t.r||n[1]!==t.g||n[2]!==t.b)&&(e.uniform3f(this.addr,t.r,t.g,t.b),n[0]=t.r,n[1]=t.g,n[2]=t.b);else{if(Q(n,t))return;e.uniform3fv(this.addr,t),$(n,t)}}function ct(e,t){var n=this.cache;if(t.x!==void 0)(n[0]!==t.x||n[1]!==t.y||n[2]!==t.z||n[3]!==t.w)&&(e.uniform4f(this.addr,t.x,t.y,t.z,t.w),n[0]=t.x,n[1]=t.y,n[2]=t.z,n[3]=t.w);else{if(Q(n,t))return;e.uniform4fv(this.addr,t),$(n,t)}}function lt(e,t){var n=this.cache,r=t.elements;if(r===void 0){if(Q(n,t))return;e.uniformMatrix2fv(this.addr,!1,t),$(n,t)}else{if(Q(n,r))return;tt.set(r),e.uniformMatrix2fv(this.addr,!1,tt),$(n,r)}}function ut(e,t){var n=this.cache,r=t.elements;if(r===void 0){if(Q(n,t))return;e.uniformMatrix3fv(this.addr,!1,t),$(n,t)}else{if(Q(n,r))return;et.set(r),e.uniformMatrix3fv(this.addr,!1,et),$(n,r)}}function dt(e,t){var n=this.cache,r=t.elements;if(r===void 0){if(Q(n,t))return;e.uniformMatrix4fv(this.addr,!1,t),$(n,t)}else{if(Q(n,r))return;$e.set(r),e.uniformMatrix4fv(this.addr,!1,$e),$(n,r)}}function ft(e,t,n){var r=this.cache,i=n.allocTextureUnit();r[0]!==i&&(e.uniform1i(this.addr,i),r[0]=i),n.setTexture2D(t||qe,i)}function pt(e,t,n){var r=this.cache,i=n.allocTextureUnit();r[0]!==i&&(e.uniform1i(this.addr,i),r[0]=i),n.setTexture3D(t||Je,i)}function mt(e,t,n){var r=this.cache,i=n.allocTextureUnit();r[0]!==i&&(e.uniform1i(this.addr,i),r[0]=i),n.setTextureCube(t||Ye,i)}function ht(e,t){var n=this.cache;Q(n,t)||(e.uniform2iv(this.addr,t),$(n,t))}function gt(e,t){var n=this.cache;Q(n,t)||(e.uniform3iv(this.addr,t),$(n,t))}function _t(e,t){var n=this.cache;Q(n,t)||(e.uniform4iv(this.addr,t),$(n,t))}function vt(e){switch(e){case 5126:return it;case 35664:return ot;case 35665:return st;case 35666:return ct;case 35674:return lt;case 35675:return ut;case 35676:return dt;case 35678:case 36198:return ft;case 35679:return pt;case 35680:return mt;case 5124:case 35670:return at;case 35667:case 35671:return ht;case 35668:case 35672:return gt;case 35669:case 35673:return _t}}function yt(e,t){var n=this.cache;Q(n,t)||(e.uniform1fv(this.addr,t),$(n,t))}function bt(e,t){var n=this.cache;Q(n,t)||(e.uniform1iv(this.addr,t),$(n,t))}function xt(e,t){var n=this.cache,r=nt(t,this.size,2);Q(n,r)||(e.uniform2fv(this.addr,r),this.updateCache(r))}function St(e,t){var n=this.cache,r=nt(t,this.size,3);Q(n,r)||(e.uniform3fv(this.addr,r),this.updateCache(r))}function Ct(e,t){var n=this.cache,r=nt(t,this.size,4);Q(n,r)||(e.uniform4fv(this.addr,r),this.updateCache(r))}function wt(e,t){var n=this.cache,r=nt(t,this.size,4);Q(n,r)||(e.uniformMatrix2fv(this.addr,!1,r),this.updateCache(r))}function Tt(e,t){var n=this.cache,r=nt(t,this.size,9);Q(n,r)||(e.uniformMatrix3fv(this.addr,!1,r),this.updateCache(r))}function Et(e,t){var n=this.cache,r=nt(t,this.size,16);Q(n,r)||(e.uniformMatrix4fv(this.addr,!1,r),this.updateCache(r))}function Dt(e,t,n){var r=this.cache,i=t.length,a=rt(n,i);Q(r,a)===!1&&(e.uniform1iv(this.addr,a),$(r,a));for(var o=0;o!==i;++o)n.setTexture2D(t[o]||qe,a[o])}function Ot(e,t,n){var r=this.cache,i=t.length,a=rt(n,i);Q(r,a)===!1&&(e.uniform1iv(this.addr,a),$(r,a));for(var o=0;o!==i;++o)n.setTextureCube(t[o]||Ye,a[o])}function kt(e){switch(e){case 5126:return yt;case 35664:return xt;case 35665:return St;case 35666:return Ct;case 35674:return wt;case 35675:return Tt;case 35676:return Et;case 35678:return Dt;case 35680:return Ot;case 5124:case 35670:return bt;case 35667:case 35671:return ht;case 35668:case 35672:return gt;case 35669:case 35673:return _t}}function At(e,t,n){this.id=e,this.addr=n,this.cache=[],this.setValue=vt(t.type)}function jt(e,t,n){this.id=e,this.addr=n,this.cache=[],this.size=t.size,this.setValue=kt(t.type)}jt.prototype.updateCache=function(e){var t=this.cache;e instanceof Float32Array&&t.length!==e.length&&(this.cache=new Float32Array(e.length)),$(t,e)};function Mt(e){this.id=e,Xe.call(this)}Mt.prototype.setValue=function(e,t,n){for(var r=this.seq,i=0,a=r.length;i!==a;++i){var o=r[i];o.setValue(e,t[o.id],n)}};var Nt=/([\w\d_]+)(\])?(\[|\.)?/g;function Pt(e,t){e.seq.push(t),e.map[t.id]=t}function Ft(e,t,n){var r=e.name,i=r.length;for(Nt.lastIndex=0;;){var a=Nt.exec(r),o=Nt.lastIndex,s=a[1],c=a[2]===`]`,l=a[3];if(c&&(s|=0),l===void 0||l===`[`&&o+2===i){Pt(n,l===void 0?new At(s,e,t):new jt(s,e,t));break}else{var u=n.map[s];u===void 0&&(u=new Mt(s),Pt(n,u)),n=u}}}function It(e,t,n){Xe.call(this),this.renderer=n;for(var r=e.getProgramParameter(t,e.ACTIVE_UNIFORMS),i=0;i<r;++i){var a=e.getActiveUniform(t,i);Ft(a,e.getUniformLocation(t,a.name),this)}}It.prototype.setValue=function(e,t,n){var r=this.map[t];r!==void 0&&r.setValue(e,n,this.renderer)},It.prototype.setOptional=function(e,t,n){var r=t[n];r!==void 0&&this.setValue(e,n,r)},It.upload=function(e,t,n,r){for(var i=0,a=t.length;i!==a;++i){var o=t[i],s=n[o.id];s.needsUpdate!==!1&&o.setValue(e,s.value,r)}},It.seqWithValue=function(e,t){for(var n=[],r=0,i=e.length;r!==i;++r){var a=e[r];a.id in t&&n.push(a)}return n};function Lt(e){for(var t=e.split(`
`),n=0;n<t.length;n++)t[n]=n+1+`: `+t[n];return t.join(`
`)}function Rt(e,t,n){var r=e.createShader(t);return e.shaderSource(r,n),e.compileShader(r),e.getShaderParameter(r,e.COMPILE_STATUS)===!1&&console.error(`THREE.WebGLShader: Shader couldn't compile.`),e.getShaderInfoLog(r)!==``&&console.warn(`THREE.WebGLShader: gl.getShaderInfoLog()`,t===e.VERTEX_SHADER?`vertex`:`fragment`,e.getShaderInfoLog(r),Lt(n)),r}var zt=0;function Bt(e){switch(e){case h:return[`Linear`,`( value )`];case g:return[`sRGB`,`( value )`];case v:return[`RGBE`,`( value )`];case y:return[`RGBM`,`( value, 7.0 )`];case b:return[`RGBM`,`( value, 16.0 )`];case x:return[`RGBD`,`( value, 256.0 )`];case _:return[`Gamma`,`( value, float( GAMMA_FACTOR ) )`];default:throw Error(`unsupported encoding: `+e)}}function Vt(e,t){var n=Bt(t);return`vec4 `+e+`( vec4 value ) { return `+n[0]+`ToLinear`+n[1]+`; }`}function Ht(e,t){var n=Bt(t);return`vec4 `+e+`( vec4 value ) { return LinearTo`+n[0]+n[1]+`; }`}function Ut(e,t){var n;switch(t){case 1:n=`Linear`;break;case 2:n=`Reinhard`;break;case 3:n=`Uncharted2`;break;case 4:n=`OptimizedCineon`;break;case 5:n=`ACESFilmic`;break;default:throw Error(`unsupported toneMapping: `+t)}return`vec3 `+e+`( vec3 color ) { return `+n+`ToneMapping( color ); }`}function Wt(e,t,n){return e||={},[e.derivatives||t.envMapCubeUV||t.bumpMap||t.normalMap&&!t.objectSpaceNormalMap||t.flatShading?`#extension GL_OES_standard_derivatives : enable`:``,(e.fragDepth||t.logarithmicDepthBuffer)&&n.get(`EXT_frag_depth`)?`#extension GL_EXT_frag_depth : enable`:``,e.drawBuffers&&n.get(`WEBGL_draw_buffers`)?`#extension GL_EXT_draw_buffers : require`:``,(e.shaderTextureLOD||t.envMap)&&n.get(`EXT_shader_texture_lod`)?`#extension GL_EXT_shader_texture_lod : enable`:``].filter(qt).join(`
`)}function Gt(e){var t=[];for(var n in e){var r=e[n];r!==!1&&t.push(`#define `+n+` `+r)}return t.join(`
`)}function Kt(e,t){for(var n={},r=e.getProgramParameter(t,e.ACTIVE_ATTRIBUTES),i=0;i<r;i++){var a=e.getActiveAttrib(t,i).name;n[a]=e.getAttribLocation(t,a)}return n}function qt(e){return e!==``}function Jt(e,t){return e.replace(/NUM_DIR_LIGHTS/g,t.numDirLights).replace(/NUM_SPOT_LIGHTS/g,t.numSpotLights).replace(/NUM_RECT_AREA_LIGHTS/g,t.numRectAreaLights).replace(/NUM_POINT_LIGHTS/g,t.numPointLights).replace(/NUM_HEMI_LIGHTS/g,t.numHemiLights)}function Yt(e,t){return e.replace(/NUM_CLIPPING_PLANES/g,t.numClippingPlanes).replace(/UNION_CLIPPING_PLANES/g,t.numClippingPlanes-t.numClipIntersection)}function Xt(e){var t=/^[ \t]*#include +<([\w\d./]+)>/gm;function n(e,t){var n=X[t];if(n===void 0)throw Error(`Can not resolve #include <`+t+`>`);return Xt(n)}return e.replace(t,n)}function Zt(e){var t=/#pragma unroll_loop[\s]+?for \( int i \= (\d+)\; i < (\d+)\; i \+\+ \) \{([\s\S]+?)(?=\})\}/g;function n(e,t,n,r){for(var i=``,a=parseInt(t);a<parseInt(n);a++)i+=r.replace(/\[ i \]/g,`[ `+a+` ]`);return i}return e.replace(t,n)}function Qt(e,t,n,r,i,a,o){var s=e.context,c=r.defines,l=i.vertexShader,u=i.fragmentShader,d=`SHADOWMAP_TYPE_BASIC`;a.shadowMapType===1?d=`SHADOWMAP_TYPE_PCF`:a.shadowMapType===2&&(d=`SHADOWMAP_TYPE_PCF_SOFT`);var f=`ENVMAP_TYPE_CUBE`,p=`ENVMAP_MODE_REFLECTION`,m=`ENVMAP_BLENDING_MULTIPLY`;if(a.envMap){switch(r.envMap.mapping){case 301:case 302:f=`ENVMAP_TYPE_CUBE`;break;case 306:case 307:f=`ENVMAP_TYPE_CUBE_UV`;break;case 303:case 304:f=`ENVMAP_TYPE_EQUIREC`;break;case 305:f=`ENVMAP_TYPE_SPHERE`;break}switch(r.envMap.mapping){case 302:case 304:p=`ENVMAP_MODE_REFRACTION`;break}switch(r.combine){case 0:m=`ENVMAP_BLENDING_MULTIPLY`;break;case 1:m=`ENVMAP_BLENDING_MIX`;break;case 2:m=`ENVMAP_BLENDING_ADD`;break}}var h=e.gammaFactor>0?e.gammaFactor:1,g=o.isWebGL2?``:Wt(r.extensions,a,t),_=Gt(c),v=s.createProgram(),y,b;if(r.isRawShaderMaterial?(y=[_].filter(qt).join(`
`),y.length>0&&(y+=`
`),b=[g,_].filter(qt).join(`
`),b.length>0&&(b+=`
`)):(y=[`precision `+a.precision+` float;`,`precision `+a.precision+` int;`,`#define SHADER_NAME `+i.name,_,a.supportsVertexTextures?`#define VERTEX_TEXTURES`:``,`#define GAMMA_FACTOR `+h,`#define MAX_BONES `+a.maxBones,a.useFog&&a.fog?`#define USE_FOG`:``,a.useFog&&a.fogExp?`#define FOG_EXP2`:``,a.map?`#define USE_MAP`:``,a.envMap?`#define USE_ENVMAP`:``,a.envMap?`#define `+p:``,a.lightMap?`#define USE_LIGHTMAP`:``,a.aoMap?`#define USE_AOMAP`:``,a.emissiveMap?`#define USE_EMISSIVEMAP`:``,a.bumpMap?`#define USE_BUMPMAP`:``,a.normalMap?`#define USE_NORMALMAP`:``,a.normalMap&&a.objectSpaceNormalMap?`#define OBJECTSPACE_NORMALMAP`:``,a.displacementMap&&a.supportsVertexTextures?`#define USE_DISPLACEMENTMAP`:``,a.specularMap?`#define USE_SPECULARMAP`:``,a.roughnessMap?`#define USE_ROUGHNESSMAP`:``,a.metalnessMap?`#define USE_METALNESSMAP`:``,a.alphaMap?`#define USE_ALPHAMAP`:``,a.vertexColors?`#define USE_COLOR`:``,a.flatShading?`#define FLAT_SHADED`:``,a.skinning?`#define USE_SKINNING`:``,a.useVertexTexture?`#define BONE_TEXTURE`:``,a.morphTargets?`#define USE_MORPHTARGETS`:``,a.morphNormals&&a.flatShading===!1?`#define USE_MORPHNORMALS`:``,a.doubleSided?`#define DOUBLE_SIDED`:``,a.flipSided?`#define FLIP_SIDED`:``,a.shadowMapEnabled?`#define USE_SHADOWMAP`:``,a.shadowMapEnabled?`#define `+d:``,a.sizeAttenuation?`#define USE_SIZEATTENUATION`:``,a.logarithmicDepthBuffer?`#define USE_LOGDEPTHBUF`:``,a.logarithmicDepthBuffer&&(o.isWebGL2||t.get(`EXT_frag_depth`))?`#define USE_LOGDEPTHBUF_EXT`:``,`uniform mat4 modelMatrix;`,`uniform mat4 modelViewMatrix;`,`uniform mat4 projectionMatrix;`,`uniform mat4 viewMatrix;`,`uniform mat3 normalMatrix;`,`uniform vec3 cameraPosition;`,`attribute vec3 position;`,`attribute vec3 normal;`,`attribute vec2 uv;`,`#ifdef USE_COLOR`,`	attribute vec3 color;`,`#endif`,`#ifdef USE_MORPHTARGETS`,`	attribute vec3 morphTarget0;`,`	attribute vec3 morphTarget1;`,`	attribute vec3 morphTarget2;`,`	attribute vec3 morphTarget3;`,`	#ifdef USE_MORPHNORMALS`,`		attribute vec3 morphNormal0;`,`		attribute vec3 morphNormal1;`,`		attribute vec3 morphNormal2;`,`		attribute vec3 morphNormal3;`,`	#else`,`		attribute vec3 morphTarget4;`,`		attribute vec3 morphTarget5;`,`		attribute vec3 morphTarget6;`,`		attribute vec3 morphTarget7;`,`	#endif`,`#endif`,`#ifdef USE_SKINNING`,`	attribute vec4 skinIndex;`,`	attribute vec4 skinWeight;`,`#endif`,`
`].filter(qt).join(`
`),b=[g,`precision `+a.precision+` float;`,`precision `+a.precision+` int;`,`#define SHADER_NAME `+i.name,_,a.alphaTest?`#define ALPHATEST `+a.alphaTest+(a.alphaTest%1?``:`.0`):``,`#define GAMMA_FACTOR `+h,a.useFog&&a.fog?`#define USE_FOG`:``,a.useFog&&a.fogExp?`#define FOG_EXP2`:``,a.map?`#define USE_MAP`:``,a.matcap?`#define USE_MATCAP`:``,a.envMap?`#define USE_ENVMAP`:``,a.envMap?`#define `+f:``,a.envMap?`#define `+p:``,a.envMap?`#define `+m:``,a.lightMap?`#define USE_LIGHTMAP`:``,a.aoMap?`#define USE_AOMAP`:``,a.emissiveMap?`#define USE_EMISSIVEMAP`:``,a.bumpMap?`#define USE_BUMPMAP`:``,a.normalMap?`#define USE_NORMALMAP`:``,a.normalMap&&a.objectSpaceNormalMap?`#define OBJECTSPACE_NORMALMAP`:``,a.specularMap?`#define USE_SPECULARMAP`:``,a.roughnessMap?`#define USE_ROUGHNESSMAP`:``,a.metalnessMap?`#define USE_METALNESSMAP`:``,a.alphaMap?`#define USE_ALPHAMAP`:``,a.vertexColors?`#define USE_COLOR`:``,a.gradientMap?`#define USE_GRADIENTMAP`:``,a.flatShading?`#define FLAT_SHADED`:``,a.doubleSided?`#define DOUBLE_SIDED`:``,a.flipSided?`#define FLIP_SIDED`:``,a.shadowMapEnabled?`#define USE_SHADOWMAP`:``,a.shadowMapEnabled?`#define `+d:``,a.premultipliedAlpha?`#define PREMULTIPLIED_ALPHA`:``,a.physicallyCorrectLights?`#define PHYSICALLY_CORRECT_LIGHTS`:``,a.logarithmicDepthBuffer?`#define USE_LOGDEPTHBUF`:``,a.logarithmicDepthBuffer&&(o.isWebGL2||t.get(`EXT_frag_depth`))?`#define USE_LOGDEPTHBUF_EXT`:``,a.envMap&&(o.isWebGL2||t.get(`EXT_shader_texture_lod`))?`#define TEXTURE_LOD_EXT`:``,`uniform mat4 viewMatrix;`,`uniform vec3 cameraPosition;`,a.toneMapping===0?``:`#define TONE_MAPPING`,a.toneMapping===0?``:X.tonemapping_pars_fragment,a.toneMapping===0?``:Ut(`toneMapping`,a.toneMapping),a.dithering?`#define DITHERING`:``,a.outputEncoding||a.mapEncoding||a.matcapEncoding||a.envMapEncoding||a.emissiveMapEncoding?X.encodings_pars_fragment:``,a.mapEncoding?Vt(`mapTexelToLinear`,a.mapEncoding):``,a.matcapEncoding?Vt(`matcapTexelToLinear`,a.matcapEncoding):``,a.envMapEncoding?Vt(`envMapTexelToLinear`,a.envMapEncoding):``,a.emissiveMapEncoding?Vt(`emissiveMapTexelToLinear`,a.emissiveMapEncoding):``,a.outputEncoding?Ht(`linearToOutputTexel`,a.outputEncoding):``,a.depthPacking?`#define DEPTH_PACKING `+r.depthPacking:``,`
`].filter(qt).join(`
`)),l=Xt(l),l=Jt(l,a),l=Yt(l,a),u=Xt(u),u=Jt(u,a),u=Yt(u,a),l=Zt(l),u=Zt(u),o.isWebGL2&&!r.isRawShaderMaterial){var x=!1,S=/^\s*#version\s+300\s+es\s*\n/;r.isShaderMaterial&&l.match(S)!==null&&u.match(S)!==null&&(x=!0,l=l.replace(S,``),u=u.replace(S,``)),y=[`#version 300 es
`,`#define attribute in`,`#define varying out`,`#define texture2D texture`].join(`
`)+`
`+y,b=[`#version 300 es
`,`#define varying in`,x?``:`out highp vec4 pc_fragColor;`,x?``:`#define gl_FragColor pc_fragColor`,`#define gl_FragDepthEXT gl_FragDepth`,`#define texture2D texture`,`#define textureCube texture`,`#define texture2DProj textureProj`,`#define texture2DLodEXT textureLod`,`#define texture2DProjLodEXT textureProjLod`,`#define textureCubeLodEXT textureLod`,`#define texture2DGradEXT textureGrad`,`#define texture2DProjGradEXT textureProjGrad`,`#define textureCubeGradEXT textureGrad`].join(`
`)+`
`+b}var C=y+l,w=b+u,T=Rt(s,s.VERTEX_SHADER,C),E=Rt(s,s.FRAGMENT_SHADER,w);s.attachShader(v,T),s.attachShader(v,E),r.index0AttributeName===void 0?a.morphTargets===!0&&s.bindAttribLocation(v,0,`position`):s.bindAttribLocation(v,0,r.index0AttributeName),s.linkProgram(v);var D=s.getProgramInfoLog(v).trim(),O=s.getShaderInfoLog(T).trim(),k=s.getShaderInfoLog(E).trim(),A=!0,j=!0;s.getProgramParameter(v,s.LINK_STATUS)===!1?(A=!1,console.error(`THREE.WebGLProgram: shader error: `,s.getError(),`gl.VALIDATE_STATUS`,s.getProgramParameter(v,s.VALIDATE_STATUS),`gl.getProgramInfoLog`,D,O,k)):D===``?(O===``||k===``)&&(j=!1):console.warn(`THREE.WebGLProgram: gl.getProgramInfoLog()`,D),j&&(this.diagnostics={runnable:A,material:r,programLog:D,vertexShader:{log:O,prefix:y},fragmentShader:{log:k,prefix:b}}),s.deleteShader(T),s.deleteShader(E);var M;this.getUniforms=function(){return M===void 0&&(M=new It(s,v,e)),M};var N;return this.getAttributes=function(){return N===void 0&&(N=Kt(s,v)),N},this.destroy=function(){s.deleteProgram(v),this.program=void 0},Object.defineProperties(this,{uniforms:{get:function(){return console.warn(`THREE.WebGLProgram: .uniforms is now .getUniforms().`),this.getUniforms()}},attributes:{get:function(){return console.warn(`THREE.WebGLProgram: .attributes is now .getAttributes().`),this.getAttributes()}}}),this.name=i.name,this.id=zt++,this.code=n,this.usedTimes=1,this.program=v,this.vertexShader=T,this.fragmentShader=E,this}function $t(e,t,n){var r=[],i={MeshDepthMaterial:`depth`,MeshDistanceMaterial:`distanceRGBA`,MeshNormalMaterial:`normal`,MeshBasicMaterial:`basic`,MeshLambertMaterial:`lambert`,MeshPhongMaterial:`phong`,MeshToonMaterial:`phong`,MeshStandardMaterial:`physical`,MeshPhysicalMaterial:`physical`,MeshMatcapMaterial:`matcap`,LineBasicMaterial:`basic`,LineDashedMaterial:`dashed`,PointsMaterial:`points`,ShadowMaterial:`shadow`,SpriteMaterial:`sprite`},a=`precision.supportsVertexTextures.map.mapEncoding.matcap.matcapEncoding.envMap.envMapMode.envMapEncoding.lightMap.aoMap.emissiveMap.emissiveMapEncoding.bumpMap.normalMap.objectSpaceNormalMap.displacementMap.specularMap.roughnessMap.metalnessMap.gradientMap.alphaMap.combine.vertexColors.fog.useFog.fogExp.flatShading.sizeAttenuation.logarithmicDepthBuffer.skinning.maxBones.useVertexTexture.morphTargets.morphNormals.maxMorphTargets.maxMorphNormals.premultipliedAlpha.numDirLights.numPointLights.numSpotLights.numHemiLights.numRectAreaLights.shadowMapEnabled.shadowMapType.toneMapping.physicallyCorrectLights.alphaTest.doubleSided.flipSided.numClippingPlanes.numClipIntersection.depthPacking.dithering`.split(`.`);function o(e){var t=e.skeleton.bones;if(n.floatVertexTextures)return 1024;var r=n.maxVertexUniforms,i=Math.floor((r-20)/4),a=Math.min(i,t.length);return a<t.length?(console.warn(`THREE.WebGLRenderer: Skeleton has `+t.length+` bones. This GPU supports `+a+`.`),0):a}function s(e,t){var n;return e?e.isTexture?n=e.encoding:e.isWebGLRenderTarget&&(console.warn(`THREE.WebGLPrograms.getTextureEncodingFromMap: don't use render targets as textures. Use their .texture property instead.`),n=e.texture.encoding):n=h,n===3e3&&t&&(n=_),n}this.getParameters=function(t,r,a,c,l,u,d){var f=i[t.type],p=d.isSkinnedMesh?o(d):0,m=n.precision;t.precision!==null&&(m=n.getMaxPrecision(t.precision),m!==t.precision&&console.warn(`THREE.WebGLProgram.getParameters:`,t.precision,`not supported, using`,m,`instead.`));var h=e.getRenderTarget();return{shaderID:f,precision:m,supportsVertexTextures:n.vertexTextures,outputEncoding:s(h?h.texture:null,e.gammaOutput),map:!!t.map,mapEncoding:s(t.map,e.gammaInput),matcap:!!t.matcap,matcapEncoding:s(t.matcap,e.gammaInput),envMap:!!t.envMap,envMapMode:t.envMap&&t.envMap.mapping,envMapEncoding:s(t.envMap,e.gammaInput),envMapCubeUV:!!t.envMap&&(t.envMap.mapping===306||t.envMap.mapping===307),lightMap:!!t.lightMap,aoMap:!!t.aoMap,emissiveMap:!!t.emissiveMap,emissiveMapEncoding:s(t.emissiveMap,e.gammaInput),bumpMap:!!t.bumpMap,normalMap:!!t.normalMap,objectSpaceNormalMap:t.normalMapType===1,displacementMap:!!t.displacementMap,roughnessMap:!!t.roughnessMap,metalnessMap:!!t.metalnessMap,specularMap:!!t.specularMap,alphaMap:!!t.alphaMap,gradientMap:!!t.gradientMap,combine:t.combine,vertexColors:t.vertexColors,fog:!!c,useFog:t.fog,fogExp:c&&c.isFogExp2,flatShading:t.flatShading,sizeAttenuation:t.sizeAttenuation,logarithmicDepthBuffer:n.logarithmicDepthBuffer,skinning:t.skinning&&p>0,maxBones:p,useVertexTexture:n.floatVertexTextures,morphTargets:t.morphTargets,morphNormals:t.morphNormals,maxMorphTargets:e.maxMorphTargets,maxMorphNormals:e.maxMorphNormals,numDirLights:r.directional.length,numPointLights:r.point.length,numSpotLights:r.spot.length,numRectAreaLights:r.rectArea.length,numHemiLights:r.hemi.length,numClippingPlanes:l,numClipIntersection:u,dithering:t.dithering,shadowMapEnabled:e.shadowMap.enabled&&d.receiveShadow&&a.length>0,shadowMapType:e.shadowMap.type,toneMapping:e.toneMapping,physicallyCorrectLights:e.physicallyCorrectLights,premultipliedAlpha:t.premultipliedAlpha,alphaTest:t.alphaTest,doubleSided:t.side===2,flipSided:t.side===1,depthPacking:t.depthPacking!==void 0&&t.depthPacking}},this.getProgramCode=function(t,n){var r=[];if(n.shaderID?r.push(n.shaderID):(r.push(t.fragmentShader),r.push(t.vertexShader)),t.defines!==void 0)for(var i in t.defines)r.push(i),r.push(t.defines[i]);for(var o=0;o<a.length;o++)r.push(n[a[o]]);return r.push(t.onBeforeCompile.toString()),r.push(e.gammaOutput),r.push(e.gammaFactor),r.join()},this.acquireProgram=function(i,a,o,s){for(var c,l=0,u=r.length;l<u;l++){var d=r[l];if(d.code===s){c=d,++c.usedTimes;break}}return c===void 0&&(c=new Qt(e,t,s,i,a,o,n),r.push(c)),c},this.releaseProgram=function(e){if(--e.usedTimes===0){var t=r.indexOf(e);r[t]=r[r.length-1],r.pop(),e.destroy()}},this.programs=r}function en(){var e=new WeakMap;function t(t){var n=e.get(t);return n===void 0&&(n={},e.set(t,n)),n}function n(t){e.delete(t)}function r(t,n,r){e.get(t)[n]=r}function i(){e=new WeakMap}return{get:t,remove:n,update:r,dispose:i}}function tn(e,t){return e.groupOrder===t.groupOrder?e.renderOrder===t.renderOrder?e.program&&t.program&&e.program!==t.program?e.program.id-t.program.id:e.material.id===t.material.id?e.z===t.z?e.id-t.id:e.z-t.z:e.material.id-t.material.id:e.renderOrder-t.renderOrder:e.groupOrder-t.groupOrder}function nn(e,t){return e.groupOrder===t.groupOrder?e.renderOrder===t.renderOrder?e.z===t.z?e.id-t.id:t.z-e.z:e.renderOrder-t.renderOrder:e.groupOrder-t.groupOrder}function rn(){var e=[],t=0,n=[],r=[];function i(){t=0,n.length=0,r.length=0}function a(n,r,i,a,o,s){var c=e[t];return c===void 0?(c={id:n.id,object:n,geometry:r,material:i,program:i.program,groupOrder:a,renderOrder:n.renderOrder,z:o,group:s},e[t]=c):(c.id=n.id,c.object=n,c.geometry=r,c.material=i,c.program=i.program,c.groupOrder=a,c.renderOrder=n.renderOrder,c.z=o,c.group=s),t++,c}function o(e,t,i,o,s,c){var l=a(e,t,i,o,s,c);(i.transparent===!0?r:n).push(l)}function s(e,t,i,o,s,c){var l=a(e,t,i,o,s,c);(i.transparent===!0?r:n).unshift(l)}function c(){n.length>1&&n.sort(tn),r.length>1&&r.sort(nn)}return{opaque:n,transparent:r,init:i,push:o,unshift:s,sort:c}}function an(){var e={};function t(n){var r=n.target;r.removeEventListener(`dispose`,t),delete e[r.id]}function n(n,r){var i=e[n.id],a;return i===void 0?(a=new rn,e[n.id]={},e[n.id][r.id]=a,n.addEventListener(`dispose`,t)):(a=i[r.id],a===void 0&&(a=new rn,i[r.id]=a)),a}function r(){e={}}return{get:n,dispose:r}}function on(){var e={};return{get:function(t){if(e[t.id]!==void 0)return e[t.id];var n;switch(t.type){case`DirectionalLight`:n={direction:new O,color:new V,shadow:!1,shadowBias:0,shadowRadius:1,shadowMapSize:new T};break;case`SpotLight`:n={position:new O,direction:new O,color:new V,distance:0,coneCos:0,penumbraCos:0,decay:0,shadow:!1,shadowBias:0,shadowRadius:1,shadowMapSize:new T};break;case`PointLight`:n={position:new O,color:new V,distance:0,decay:0,shadow:!1,shadowBias:0,shadowRadius:1,shadowMapSize:new T,shadowCameraNear:1,shadowCameraFar:1e3};break;case`HemisphereLight`:n={direction:new O,skyColor:new V,groundColor:new V};break;case`RectAreaLight`:n={color:new V,position:new O,halfWidth:new O,halfHeight:new O};break}return e[t.id]=n,n}}}var sn=0;function cn(){var e=new on,t={id:sn++,hash:{stateID:-1,directionalLength:-1,pointLength:-1,spotLength:-1,rectAreaLength:-1,hemiLength:-1,shadowsLength:-1},ambient:[0,0,0],directional:[],directionalShadowMap:[],directionalShadowMatrix:[],spot:[],spotShadowMap:[],spotShadowMatrix:[],rectArea:[],point:[],pointShadowMap:[],pointShadowMatrix:[],hemi:[]},n=new O,r=new E,i=new E;function a(a,o,s){for(var c=0,l=0,u=0,d=0,f=0,p=0,m=0,h=0,g=s.matrixWorldInverse,_=0,v=a.length;_<v;_++){var y=a[_],b=y.color,x=y.intensity,S=y.distance,C=y.shadow&&y.shadow.map?y.shadow.map.texture:null;if(y.isAmbientLight)c+=b.r*x,l+=b.g*x,u+=b.b*x;else if(y.isDirectionalLight){var w=e.get(y);if(w.color.copy(y.color).multiplyScalar(y.intensity),w.direction.setFromMatrixPosition(y.matrixWorld),n.setFromMatrixPosition(y.target.matrixWorld),w.direction.sub(n),w.direction.transformDirection(g),w.shadow=y.castShadow,y.castShadow){var T=y.shadow;w.shadowBias=T.bias,w.shadowRadius=T.radius,w.shadowMapSize=T.mapSize}t.directionalShadowMap[d]=C,t.directionalShadowMatrix[d]=y.shadow.matrix,t.directional[d]=w,d++}else if(y.isSpotLight){var w=e.get(y);if(w.position.setFromMatrixPosition(y.matrixWorld),w.position.applyMatrix4(g),w.color.copy(b).multiplyScalar(x),w.distance=S,w.direction.setFromMatrixPosition(y.matrixWorld),n.setFromMatrixPosition(y.target.matrixWorld),w.direction.sub(n),w.direction.transformDirection(g),w.coneCos=Math.cos(y.angle),w.penumbraCos=Math.cos(y.angle*(1-y.penumbra)),w.decay=y.decay,w.shadow=y.castShadow,y.castShadow){var T=y.shadow;w.shadowBias=T.bias,w.shadowRadius=T.radius,w.shadowMapSize=T.mapSize}t.spotShadowMap[p]=C,t.spotShadowMatrix[p]=y.shadow.matrix,t.spot[p]=w,p++}else if(y.isRectAreaLight){var w=e.get(y);w.color.copy(b).multiplyScalar(x),w.position.setFromMatrixPosition(y.matrixWorld),w.position.applyMatrix4(g),i.identity(),r.copy(y.matrixWorld),r.premultiply(g),i.extractRotation(r),w.halfWidth.set(y.width*.5,0,0),w.halfHeight.set(0,y.height*.5,0),w.halfWidth.applyMatrix4(i),w.halfHeight.applyMatrix4(i),t.rectArea[m]=w,m++}else if(y.isPointLight){var w=e.get(y);if(w.position.setFromMatrixPosition(y.matrixWorld),w.position.applyMatrix4(g),w.color.copy(y.color).multiplyScalar(y.intensity),w.distance=y.distance,w.decay=y.decay,w.shadow=y.castShadow,y.castShadow){var T=y.shadow;w.shadowBias=T.bias,w.shadowRadius=T.radius,w.shadowMapSize=T.mapSize,w.shadowCameraNear=T.camera.near,w.shadowCameraFar=T.camera.far}t.pointShadowMap[f]=C,t.pointShadowMatrix[f]=y.shadow.matrix,t.point[f]=w,f++}else if(y.isHemisphereLight){var w=e.get(y);w.direction.setFromMatrixPosition(y.matrixWorld),w.direction.transformDirection(g),w.direction.normalize(),w.skyColor.copy(y.color).multiplyScalar(x),w.groundColor.copy(y.groundColor).multiplyScalar(x),t.hemi[h]=w,h++}}t.ambient[0]=c,t.ambient[1]=l,t.ambient[2]=u,t.directional.length=d,t.spot.length=p,t.rectArea.length=m,t.point.length=f,t.hemi.length=h,t.hash.stateID=t.id,t.hash.directionalLength=d,t.hash.pointLength=f,t.hash.spotLength=p,t.hash.rectAreaLength=m,t.hash.hemiLength=h,t.hash.shadowsLength=o.length}return{setup:a,state:t}}function ln(){var e=new cn,t=[],n=[];function r(){t.length=0,n.length=0}function i(e){t.push(e)}function a(e){n.push(e)}function o(r){e.setup(t,n,r)}return{init:r,state:{lightsArray:t,shadowsArray:n,lights:e},setupLights:o,pushLight:i,pushShadow:a}}function un(){var e={};function t(n){var r=n.target;r.removeEventListener(`dispose`,t),delete e[r.id]}function n(n,r){var i;return e[n.id]===void 0?(i=new ln,e[n.id]={},e[n.id][r.id]=i,n.addEventListener(`dispose`,t)):e[n.id][r.id]===void 0?(i=new ln,e[n.id][r.id]=i):i=e[n.id][r.id],i}function r(){e={}}return{get:n,dispose:r}}function dn(e){W.call(this),this.type=`MeshDepthMaterial`,this.depthPacking=S,this.skinning=!1,this.morphTargets=!1,this.map=null,this.alphaMap=null,this.displacementMap=null,this.displacementScale=1,this.displacementBias=0,this.wireframe=!1,this.wireframeLinewidth=1,this.fog=!1,this.lights=!1,this.setValues(e)}dn.prototype=Object.create(W.prototype),dn.prototype.constructor=dn,dn.prototype.isMeshDepthMaterial=!0,dn.prototype.copy=function(e){return W.prototype.copy.call(this,e),this.depthPacking=e.depthPacking,this.skinning=e.skinning,this.morphTargets=e.morphTargets,this.map=e.map,this.alphaMap=e.alphaMap,this.displacementMap=e.displacementMap,this.displacementScale=e.displacementScale,this.displacementBias=e.displacementBias,this.wireframe=e.wireframe,this.wireframeLinewidth=e.wireframeLinewidth,this};function fn(e){W.call(this),this.type=`MeshDistanceMaterial`,this.referencePosition=new O,this.nearDistance=1,this.farDistance=1e3,this.skinning=!1,this.morphTargets=!1,this.map=null,this.alphaMap=null,this.displacementMap=null,this.displacementScale=1,this.displacementBias=0,this.fog=!1,this.lights=!1,this.setValues(e)}fn.prototype=Object.create(W.prototype),fn.prototype.constructor=fn,fn.prototype.isMeshDistanceMaterial=!0,fn.prototype.copy=function(e){return W.prototype.copy.call(this,e),this.referencePosition.copy(e.referencePosition),this.nearDistance=e.nearDistance,this.farDistance=e.farDistance,this.skinning=e.skinning,this.morphTargets=e.morphTargets,this.map=e.map,this.alphaMap=e.alphaMap,this.displacementMap=e.displacementMap,this.displacementScale=e.displacementScale,this.displacementBias=e.displacementBias,this};function pn(e,t,n){for(var r=new Oe,i=new E,a=new T,s=new T(n,n),c=new O,l=new O,u=1,d=2,f=(u|d)+1,p=Array(f),h=Array(f),g={},_={0:1,1:0,2:2},v=[new O(1,0,0),new O(-1,0,0),new O(0,0,1),new O(0,0,-1),new O(0,1,0),new O(0,-1,0)],y=[new O(0,1,0),new O(0,1,0),new O(0,1,0),new O(0,1,0),new O(0,0,1),new O(0,0,-1)],b=[new K,new K,new K,new K,new K,new K],x=0;x!==f;++x){var S=(x&u)!==0,w=(x&d)!==0;p[x]=new dn({depthPacking:C,morphTargets:S,skinning:w}),h[x]=new fn({morphTargets:S,skinning:w})}var D=this;this.enabled=!1,this.autoUpdate=!0,this.needsUpdate=!1,this.type=1,this.render=function(t,n,u){if(D.enabled!==!1&&!(D.autoUpdate===!1&&D.needsUpdate===!1)&&t.length!==0){var d=e.state;d.setBlending(0),d.buffers.color.setClear(1,1,1,1),d.buffers.depth.setTest(!0),d.setScissorTest(!1);for(var f,p=0,h=t.length;p<h;p++){var g=t[p],_=g.shadow,x=g&&g.isPointLight;if(_===void 0){console.warn(`THREE.WebGLShadowMap:`,g,`has no shadow.`);continue}var S=_.camera;if(a.copy(_.mapSize),a.min(s),x){var C=a.x,w=a.y;b[0].set(C*2,w,C,w),b[1].set(0,w,C,w),b[2].set(C*3,w,C,w),b[3].set(C,w,C,w),b[4].set(C*3,0,C,w),b[5].set(C,0,C,w),a.x*=4,a.y*=2}if(_.map===null){var T={minFilter:o,magFilter:o,format:m};_.map=new Te(a.x,a.y,T),_.map.texture.name=g.name+`.shadowMap`,S.updateProjectionMatrix()}_.isSpotLightShadow&&_.update(g);var E=_.map,O=_.matrix;l.setFromMatrixPosition(g.matrixWorld),S.position.copy(l),x?(f=6,O.makeTranslation(-l.x,-l.y,-l.z)):(f=1,c.setFromMatrixPosition(g.target.matrixWorld),S.lookAt(c),S.updateMatrixWorld(),O.set(.5,0,0,.5,0,.5,0,.5,0,0,.5,.5,0,0,0,1),O.multiply(S.projectionMatrix),O.multiply(S.matrixWorldInverse)),e.setRenderTarget(E),e.clear();for(var k=0;k<f;k++){if(x){c.copy(S.position),c.add(v[k]),S.up.copy(y[k]),S.lookAt(c),S.updateMatrixWorld();var j=b[k];d.viewport(j)}i.multiplyMatrices(S.projectionMatrix,S.matrixWorldInverse),r.setFromMatrix(i),A(n,u,S,x)}}D.needsUpdate=!1}};function k(t,n,r,i,a,o){var s=t.geometry,c=null,l=p,f=t.customDepthMaterial;if(r&&(l=h,f=t.customDistanceMaterial),f)c=f;else{var m=!1;n.morphTargets&&(s&&s.isBufferGeometry?m=s.morphAttributes&&s.morphAttributes.position&&s.morphAttributes.position.length>0:s&&s.isGeometry&&(m=s.morphTargets&&s.morphTargets.length>0)),t.isSkinnedMesh&&n.skinning===!1&&console.warn(`THREE.WebGLShadowMap: THREE.SkinnedMesh with material.skinning set to false:`,t);var v=t.isSkinnedMesh&&n.skinning,y=0;m&&(y|=u),v&&(y|=d),c=l[y]}if(e.localClippingEnabled&&n.clipShadows===!0&&n.clippingPlanes.length!==0){var b=c.uuid,x=n.uuid,S=g[b];S===void 0&&(S={},g[b]=S);var C=S[x];C===void 0&&(C=c.clone(),S[x]=C),c=C}return c.visible=n.visible,c.wireframe=n.wireframe,c.side=n.shadowSide==null?_[n.side]:n.shadowSide,c.clipShadows=n.clipShadows,c.clippingPlanes=n.clippingPlanes,c.clipIntersection=n.clipIntersection,c.wireframeLinewidth=n.wireframeLinewidth,c.linewidth=n.linewidth,r&&c.isMeshDistanceMaterial&&(c.referencePosition.copy(i),c.nearDistance=a,c.farDistance=o),c}function A(n,i,a,o){if(n.visible!==!1){if(n.layers.test(i.layers)&&(n.isMesh||n.isLine||n.isPoints)&&n.castShadow&&(!n.frustumCulled||r.intersectsObject(n))){n.modelViewMatrix.multiplyMatrices(a.matrixWorldInverse,n.matrixWorld);var s=t.update(n),c=n.material;if(Array.isArray(c))for(var u=s.groups,d=0,f=u.length;d<f;d++){var p=u[d],m=c[p.materialIndex];if(m&&m.visible){var h=k(n,m,o,l,a.near,a.far);e.renderBufferDirect(a,null,s,h,n,p)}}else if(c.visible){var h=k(n,c,o,l,a.near,a.far);e.renderBufferDirect(a,null,s,h,n,null)}}for(var g=n.children,_=0,v=g.length;_<v;_++)A(g[_],i,a,o)}}}function mn(e,t,n,r){function i(){var t=!1,n=new K,r=null,i=new K(0,0,0,0);return{setMask:function(n){r!==n&&!t&&(e.colorMask(n,n,n,n),r=n)},setLocked:function(e){t=e},setClear:function(t,r,a,o,s){s===!0&&(t*=o,r*=o,a*=o),n.set(t,r,a,o),i.equals(n)===!1&&(e.clearColor(t,r,a,o),i.copy(n))},reset:function(){t=!1,r=null,i.set(-1,0,0,0)}}}function a(){var t=!1,n=null,r=null,i=null;return{setTest:function(t){t?H(e.DEPTH_TEST):U(e.DEPTH_TEST)},setMask:function(r){n!==r&&!t&&(e.depthMask(r),n=r)},setFunc:function(t){if(r!==t){if(t)switch(t){case 0:e.depthFunc(e.NEVER);break;case 1:e.depthFunc(e.ALWAYS);break;case 2:e.depthFunc(e.LESS);break;case 3:e.depthFunc(e.LEQUAL);break;case 4:e.depthFunc(e.EQUAL);break;case 5:e.depthFunc(e.GEQUAL);break;case 6:e.depthFunc(e.GREATER);break;case 7:e.depthFunc(e.NOTEQUAL);break;default:e.depthFunc(e.LEQUAL)}else e.depthFunc(e.LEQUAL);r=t}},setLocked:function(e){t=e},setClear:function(t){i!==t&&(e.clearDepth(t),i=t)},reset:function(){t=!1,n=null,r=null,i=null}}}function o(){var t=!1,n=null,r=null,i=null,a=null,o=null,s=null,c=null,l=null;return{setTest:function(t){t?H(e.STENCIL_TEST):U(e.STENCIL_TEST)},setMask:function(r){n!==r&&!t&&(e.stencilMask(r),n=r)},setFunc:function(t,n,o){(r!==t||i!==n||a!==o)&&(e.stencilFunc(t,n,o),r=t,i=n,a=o)},setOp:function(t,n,r){(o!==t||s!==n||c!==r)&&(e.stencilOp(t,n,r),o=t,s=n,c=r)},setLocked:function(e){t=e},setClear:function(t){l!==t&&(e.clearStencil(t),l=t)},reset:function(){t=!1,n=null,r=null,i=null,a=null,o=null,s=null,c=null,l=null}}}var s=new i,c=new a,l=new o,u=e.getParameter(e.MAX_VERTEX_ATTRIBS),d=new Uint8Array(u),f=new Uint8Array(u),p=new Uint8Array(u),m={},h=null,g=null,_=null,v=null,y=null,b=null,x=null,S=null,C=null,w=null,T=!1,E=null,D=null,O=null,k=null,A=null,j=e.getParameter(e.MAX_COMBINED_TEXTURE_IMAGE_UNITS),M=!1,N=0,P=e.getParameter(e.VERSION);P.indexOf(`WebGL`)===-1?P.indexOf(`OpenGL ES`)!==-1&&(N=parseFloat(/^OpenGL\ ES\ ([0-9])/.exec(P)[1]),M=N>=2):(N=parseFloat(/^WebGL\ ([0-9])/.exec(P)[1]),M=N>=1);var F=null,I={},L=new K,R=new K;function ee(t,n,r){var i=new Uint8Array(4),a=e.createTexture();e.bindTexture(t,a),e.texParameteri(t,e.TEXTURE_MIN_FILTER,e.NEAREST),e.texParameteri(t,e.TEXTURE_MAG_FILTER,e.NEAREST);for(var o=0;o<r;o++)e.texImage2D(n+o,0,e.RGBA,1,1,0,e.RGBA,e.UNSIGNED_BYTE,i);return a}var te={};te[e.TEXTURE_2D]=ee(e.TEXTURE_2D,e.TEXTURE_2D,1),te[e.TEXTURE_CUBE_MAP]=ee(e.TEXTURE_CUBE_MAP,e.TEXTURE_CUBE_MAP_POSITIVE_X,6),s.setClear(0,0,0,1),c.setClear(1),l.setClear(0),H(e.DEPTH_TEST),c.setFunc(3),ie(!1),ae(1),H(e.CULL_FACE),q(0);function z(){for(var e=0,t=d.length;e<t;e++)d[e]=0}function ne(e){B(e,0)}function B(n,i){d[n]=1,f[n]===0&&(e.enableVertexAttribArray(n),f[n]=1),p[n]!==i&&((r.isWebGL2?e:t.get(`ANGLE_instanced_arrays`))[r.isWebGL2?`vertexAttribDivisor`:`vertexAttribDivisorANGLE`](n,i),p[n]=i)}function V(){for(var t=0,n=f.length;t!==n;++t)f[t]!==d[t]&&(e.disableVertexAttribArray(t),f[t]=0)}function H(t){m[t]!==!0&&(e.enable(t),m[t]=!0)}function U(t){m[t]!==!1&&(e.disable(t),m[t]=!1)}function W(){if(h===null&&(h=[],t.get(`WEBGL_compressed_texture_pvrtc`)||t.get(`WEBGL_compressed_texture_s3tc`)||t.get(`WEBGL_compressed_texture_etc1`)||t.get(`WEBGL_compressed_texture_astc`)))for(var n=e.getParameter(e.COMPRESSED_TEXTURE_FORMATS),r=0;r<n.length;r++)h.push(n[r]);return h}function G(t){return g===t?!1:(e.useProgram(t),g=t,!0)}function q(t,r,i,a,o,s,c,l){if(t===0){_&&=(U(e.BLEND),!1);return}if(_||=(H(e.BLEND),!0),t!==5){if(t!==v||l!==T){if((y!==100||S!==100)&&(e.blendEquation(e.FUNC_ADD),y=100,S=100),l)switch(t){case 1:e.blendFuncSeparate(e.ONE,e.ONE_MINUS_SRC_ALPHA,e.ONE,e.ONE_MINUS_SRC_ALPHA);break;case 2:e.blendFunc(e.ONE,e.ONE);break;case 3:e.blendFuncSeparate(e.ZERO,e.ZERO,e.ONE_MINUS_SRC_COLOR,e.ONE_MINUS_SRC_ALPHA);break;case 4:e.blendFuncSeparate(e.ZERO,e.SRC_COLOR,e.ZERO,e.SRC_ALPHA);break;default:console.error(`THREE.WebGLState: Invalid blending: `,t);break}else switch(t){case 1:e.blendFuncSeparate(e.SRC_ALPHA,e.ONE_MINUS_SRC_ALPHA,e.ONE,e.ONE_MINUS_SRC_ALPHA);break;case 2:e.blendFunc(e.SRC_ALPHA,e.ONE);break;case 3:e.blendFunc(e.ZERO,e.ONE_MINUS_SRC_COLOR);break;case 4:e.blendFunc(e.ZERO,e.SRC_COLOR);break;default:console.error(`THREE.WebGLState: Invalid blending: `,t);break}b=null,x=null,C=null,w=null,v=t,T=l}return}o||=r,s||=i,c||=a,(r!==y||o!==S)&&(e.blendEquationSeparate(n.convert(r),n.convert(o)),y=r,S=o),(i!==b||a!==x||s!==C||c!==w)&&(e.blendFuncSeparate(n.convert(i),n.convert(a),n.convert(s),n.convert(c)),b=i,x=a,C=s,w=c),v=t,T=null}function re(t,n){t.side===2?U(e.CULL_FACE):H(e.CULL_FACE);var r=t.side===1;n&&(r=!r),ie(r),t.blending===1&&t.transparent===!1?q(0):q(t.blending,t.blendEquation,t.blendSrc,t.blendDst,t.blendEquationAlpha,t.blendSrcAlpha,t.blendDstAlpha,t.premultipliedAlpha),c.setFunc(t.depthFunc),c.setTest(t.depthTest),c.setMask(t.depthWrite),s.setMask(t.colorWrite),J(t.polygonOffset,t.polygonOffsetFactor,t.polygonOffsetUnits)}function ie(t){E!==t&&(t?e.frontFace(e.CW):e.frontFace(e.CCW),E=t)}function ae(t){t===0?U(e.CULL_FACE):(H(e.CULL_FACE),t!==D&&(t===1?e.cullFace(e.BACK):t===2?e.cullFace(e.FRONT):e.cullFace(e.FRONT_AND_BACK))),D=t}function oe(t){t!==O&&(M&&e.lineWidth(t),O=t)}function J(t,n,r){t?(H(e.POLYGON_OFFSET_FILL),(k!==n||A!==r)&&(e.polygonOffset(n,r),k=n,A=r)):U(e.POLYGON_OFFSET_FILL)}function se(t){t?H(e.SCISSOR_TEST):U(e.SCISSOR_TEST)}function ce(t){t===void 0&&(t=e.TEXTURE0+j-1),F!==t&&(e.activeTexture(t),F=t)}function Y(t,n){F===null&&ce();var r=I[F];r===void 0&&(r={type:void 0,texture:void 0},I[F]=r),(r.type!==t||r.texture!==n)&&(e.bindTexture(t,n||te[t]),r.type=t,r.texture=n)}function le(){try{e.compressedTexImage2D.apply(e,arguments)}catch(e){console.error(`THREE.WebGLState:`,e)}}function ue(){try{e.texImage2D.apply(e,arguments)}catch(e){console.error(`THREE.WebGLState:`,e)}}function de(){try{e.texImage3D.apply(e,arguments)}catch(e){console.error(`THREE.WebGLState:`,e)}}function fe(t){L.equals(t)===!1&&(e.scissor(t.x,t.y,t.z,t.w),L.copy(t))}function pe(t){R.equals(t)===!1&&(e.viewport(t.x,t.y,t.z,t.w),R.copy(t))}function me(){for(var t=0;t<f.length;t++)f[t]===1&&(e.disableVertexAttribArray(t),f[t]=0);m={},h=null,F=null,I={},g=null,v=null,E=null,D=null,s.reset(),c.reset(),l.reset()}return{buffers:{color:s,depth:c,stencil:l},initAttributes:z,enableAttribute:ne,enableAttributeAndDivisor:B,disableUnusedAttributes:V,enable:H,disable:U,getCompressedTextureFormats:W,useProgram:G,setBlending:q,setMaterial:re,setFlipSided:ie,setCullFace:ae,setLineWidth:oe,setPolygonOffset:J,setScissorTest:se,activeTexture:ce,bindTexture:Y,compressedTexImage2D:le,texImage2D:ue,texImage3D:de,scissor:fe,viewport:pe,reset:me}}function hn(e,t,n,r,i,a,o){var s={},c;function l(e,t,n,r){var i=1;if((e.width>r||e.height>r)&&(i=r/Math.max(e.width,e.height)),i<1||t===!0)if(e instanceof HTMLImageElement||e instanceof HTMLCanvasElement||e instanceof ImageBitmap){c===void 0&&(c=document.createElementNS(`http://www.w3.org/1999/xhtml`,`canvas`));var a=n?document.createElementNS(`http://www.w3.org/1999/xhtml`,`canvas`):c,o=t?w.floorPowerOfTwo:Math.floor;return a.width=o(i*e.width),a.height=o(i*e.height),a.getContext(`2d`).drawImage(e,0,0,a.width,a.height),console.warn(`THREE.WebGLRenderer: Texture has been resized from (`+e.width+`x`+e.height+`) to (`+a.width+`x`+a.height+`).`),a}else return`data`in e&&console.warn(`THREE.WebGLRenderer: Image in DataTexture is too big (`+e.width+`x`+e.height+`).`),e;return e}function d(e){return w.isPowerOfTwo(e.width)&&w.isPowerOfTwo(e.height)}function p(e){return i.isWebGL2?!1:e.wrapS!==1001||e.wrapT!==1001||e.minFilter!==1003&&e.minFilter!==1006}function m(e,t){return e.generateMipmaps&&t&&e.minFilter!==1003&&e.minFilter!==1006}function h(t,n,i,a){e.generateMipmap(t);var o=r.get(n);o.__maxMipLevel=Math.log(Math.max(i,a))*Math.LOG2E}function g(n,r){if(!i.isWebGL2)return n;var a=n;return n===e.RED&&(r===e.FLOAT&&(a=e.R32F),r===e.HALF_FLOAT&&(a=e.R16F),r===e.UNSIGNED_BYTE&&(a=e.R8)),n===e.RGB&&(r===e.FLOAT&&(a=e.RGB32F),r===e.HALF_FLOAT&&(a=e.RGB16F),r===e.UNSIGNED_BYTE&&(a=e.RGB8)),n===e.RGBA&&(r===e.FLOAT&&(a=e.RGBA32F),r===e.HALF_FLOAT&&(a=e.RGBA16F),r===e.UNSIGNED_BYTE&&(a=e.RGBA8)),a===e.R16F||a===e.R32F||a===e.RGBA16F||a===e.RGBA32F?t.get(`EXT_color_buffer_float`):(a===e.RGB16F||a===e.RGB32F)&&console.warn(`THREE.WebGLRenderer: Floating point textures with RGB format not supported. Please use RGBA instead.`),a}function _(t){return t===1003||t===1004||t===1005?e.NEAREST:e.LINEAR}function v(e){var t=e.target;t.removeEventListener(`dispose`,v),b(t),t.isVideoTexture&&delete s[t.id],o.memory.textures--}function y(e){var t=e.target;t.removeEventListener(`dispose`,y),x(t),o.memory.textures--}function b(t){var n=r.get(t);if(t.image&&n.__image__webglTextureCube)e.deleteTexture(n.__image__webglTextureCube);else{if(n.__webglInit===void 0)return;e.deleteTexture(n.__webglTexture)}r.remove(t)}function x(t){var n=r.get(t),i=r.get(t.texture);if(t){if(i.__webglTexture!==void 0&&e.deleteTexture(i.__webglTexture),t.depthTexture&&t.depthTexture.dispose(),t.isWebGLRenderTargetCube)for(var a=0;a<6;a++)e.deleteFramebuffer(n.__webglFramebuffer[a]),n.__webglDepthbuffer&&e.deleteRenderbuffer(n.__webglDepthbuffer[a]);else e.deleteFramebuffer(n.__webglFramebuffer),n.__webglDepthbuffer&&e.deleteRenderbuffer(n.__webglDepthbuffer);r.remove(t.texture),r.remove(t)}}function S(t,i){var a=r.get(t);if(t.isVideoTexture&&L(t),t.version>0&&a.__version!==t.version){var o=t.image;if(o===void 0)console.warn(`THREE.WebGLRenderer: Texture marked for update but image is undefined`);else if(o.complete===!1)console.warn(`THREE.WebGLRenderer: Texture marked for update but image is incomplete`);else{O(a,t,i);return}}n.activeTexture(e.TEXTURE0+i),n.bindTexture(e.TEXTURE_2D,a.__webglTexture)}function C(t,i){var a=r.get(t);if(t.version>0&&a.__version!==t.version){O(a,t,i);return}n.activeTexture(e.TEXTURE0+i),n.bindTexture(e.TEXTURE_3D,a.__webglTexture)}function T(t,s){var c=r.get(t);if(t.image.length===6)if(t.version>0&&c.__version!==t.version){c.__image__webglTextureCube||(t.addEventListener(`dispose`,v),c.__image__webglTextureCube=e.createTexture(),o.memory.textures++),n.activeTexture(e.TEXTURE0+s),n.bindTexture(e.TEXTURE_CUBE_MAP,c.__image__webglTextureCube),e.pixelStorei(e.UNPACK_FLIP_Y_WEBGL,t.flipY);for(var u=t&&t.isCompressedTexture,f=t.image[0]&&t.image[0].isDataTexture,p=[],_=0;_<6;_++)!u&&!f?p[_]=l(t.image[_],!1,!0,i.maxCubemapSize):p[_]=f?t.image[_].image:t.image[_];var y=p[0],b=d(y),x=a.convert(t.format),S=a.convert(t.type),C=g(x,S);D(e.TEXTURE_CUBE_MAP,t,b);for(var _=0;_<6;_++)if(!u)f?n.texImage2D(e.TEXTURE_CUBE_MAP_POSITIVE_X+_,0,C,p[_].width,p[_].height,0,x,S,p[_].data):n.texImage2D(e.TEXTURE_CUBE_MAP_POSITIVE_X+_,0,C,x,S,p[_]);else for(var w,T=p[_].mipmaps,E=0,O=T.length;E<O;E++)w=T[E],t.format!==1023&&t.format!==1022?n.getCompressedTextureFormats().indexOf(x)>-1?n.compressedTexImage2D(e.TEXTURE_CUBE_MAP_POSITIVE_X+_,E,C,w.width,w.height,0,w.data):console.warn(`THREE.WebGLRenderer: Attempt to load unsupported compressed texture format in .setTextureCube()`):n.texImage2D(e.TEXTURE_CUBE_MAP_POSITIVE_X+_,E,C,w.width,w.height,0,x,S,w.data);u?c.__maxMipLevel=T.length-1:c.__maxMipLevel=0,m(t,b)&&h(e.TEXTURE_CUBE_MAP,t,y.width,y.height),c.__version=t.version,t.onUpdate&&t.onUpdate(t)}else n.activeTexture(e.TEXTURE0+s),n.bindTexture(e.TEXTURE_CUBE_MAP,c.__image__webglTextureCube)}function E(t,i){n.activeTexture(e.TEXTURE0+i),n.bindTexture(e.TEXTURE_CUBE_MAP,r.get(t).__webglTexture)}function D(n,o,s){var c;if(s?(e.texParameteri(n,e.TEXTURE_WRAP_S,a.convert(o.wrapS)),e.texParameteri(n,e.TEXTURE_WRAP_T,a.convert(o.wrapT)),e.texParameteri(n,e.TEXTURE_MAG_FILTER,a.convert(o.magFilter)),e.texParameteri(n,e.TEXTURE_MIN_FILTER,a.convert(o.minFilter))):(e.texParameteri(n,e.TEXTURE_WRAP_S,e.CLAMP_TO_EDGE),e.texParameteri(n,e.TEXTURE_WRAP_T,e.CLAMP_TO_EDGE),(o.wrapS!==1001||o.wrapT!==1001)&&console.warn(`THREE.WebGLRenderer: Texture is not power of two. Texture.wrapS and Texture.wrapT should be set to THREE.ClampToEdgeWrapping.`),e.texParameteri(n,e.TEXTURE_MAG_FILTER,_(o.magFilter)),e.texParameteri(n,e.TEXTURE_MIN_FILTER,_(o.minFilter)),o.minFilter!==1003&&o.minFilter!==1006&&console.warn(`THREE.WebGLRenderer: Texture is not power of two. Texture.minFilter should be set to THREE.NearestFilter or THREE.LinearFilter.`)),c=t.get(`EXT_texture_filter_anisotropic`),c){if(o.type===1015&&t.get(`OES_texture_float_linear`)===null||o.type===1016&&(i.isWebGL2||t.get(`OES_texture_half_float_linear`))===null)return;(o.anisotropy>1||r.get(o).__currentAnisotropy)&&(e.texParameterf(n,c.TEXTURE_MAX_ANISOTROPY_EXT,Math.min(o.anisotropy,i.getMaxAnisotropy())),r.get(o).__currentAnisotropy=o.anisotropy)}}function O(t,r,s){var c=r.isDataTexture3D?e.TEXTURE_3D:e.TEXTURE_2D;t.__webglInit===void 0&&(t.__webglInit=!0,r.addEventListener(`dispose`,v),t.__webglTexture=e.createTexture(),o.memory.textures++),n.activeTexture(e.TEXTURE0+s),n.bindTexture(c,t.__webglTexture),e.pixelStorei(e.UNPACK_FLIP_Y_WEBGL,r.flipY),e.pixelStorei(e.UNPACK_PREMULTIPLY_ALPHA_WEBGL,r.premultiplyAlpha),e.pixelStorei(e.UNPACK_ALIGNMENT,r.unpackAlignment);var _=p(r)&&d(r.image)===!1,y=l(r.image,_,!1,i.maxTextureSize),b=d(y),x=a.convert(r.format),S=a.convert(r.type),C=g(x,S);D(c,r,b);var w,T=r.mipmaps;if(r.isDepthTexture){if(C=e.DEPTH_COMPONENT,r.type===1015){if(!i.isWebGL2)throw Error(`Float Depth Texture only supported in WebGL2.0`);C=e.DEPTH_COMPONENT32F}else i.isWebGL2&&(C=e.DEPTH_COMPONENT16);r.format===1026&&C===e.DEPTH_COMPONENT&&r.type!==1012&&r.type!==1014&&(console.warn(`THREE.WebGLRenderer: Use UnsignedShortType or UnsignedIntType for DepthFormat DepthTexture.`),r.type=u,S=a.convert(r.type)),r.format===1027&&(C=e.DEPTH_STENCIL,r.type!==1020&&(console.warn(`THREE.WebGLRenderer: Use UnsignedInt248Type for DepthStencilFormat DepthTexture.`),r.type=f,S=a.convert(r.type))),n.texImage2D(e.TEXTURE_2D,0,C,y.width,y.height,0,x,S,null)}else if(r.isDataTexture){if(T.length>0&&b){for(var E=0,O=T.length;E<O;E++)w=T[E],n.texImage2D(e.TEXTURE_2D,E,C,w.width,w.height,0,x,S,w.data);r.generateMipmaps=!1,t.__maxMipLevel=T.length-1}else n.texImage2D(e.TEXTURE_2D,0,C,y.width,y.height,0,x,S,y.data),t.__maxMipLevel=0;r.isCfxTexture&&(e.texParameterf(e.TEXTURE_2D,e.TEXTURE_WRAP_T,e.CLAMP_TO_EDGE),e.texParameterf(e.TEXTURE_2D,e.TEXTURE_WRAP_T,e.MIRRORED_REPEAT),e.texParameterf(e.TEXTURE_2D,e.TEXTURE_WRAP_T,e.REPEAT))}else if(r.isCompressedTexture){for(var E=0,O=T.length;E<O;E++)w=T[E],r.format!==1023&&r.format!==1022?n.getCompressedTextureFormats().indexOf(x)>-1?n.compressedTexImage2D(e.TEXTURE_2D,E,C,w.width,w.height,0,w.data):console.warn(`THREE.WebGLRenderer: Attempt to load unsupported compressed texture format in .uploadTexture()`):n.texImage2D(e.TEXTURE_2D,E,C,w.width,w.height,0,x,S,w.data);t.__maxMipLevel=T.length-1}else if(r.isDataTexture3D)n.texImage3D(e.TEXTURE_3D,0,C,y.width,y.height,y.depth,0,x,S,y.data),t.__maxMipLevel=0;else if(T.length>0&&b){for(var E=0,O=T.length;E<O;E++)w=T[E],n.texImage2D(e.TEXTURE_2D,E,C,x,S,w);r.generateMipmaps=!1,t.__maxMipLevel=T.length-1}else n.texImage2D(e.TEXTURE_2D,0,C,x,S,y),t.__maxMipLevel=0;m(r,b)&&h(e.TEXTURE_2D,r,y.width,y.height),t.__version=r.version,r.onUpdate&&r.onUpdate(r)}function k(t,i,o,s){var c=a.convert(i.texture.format),l=a.convert(i.texture.type),u=g(c,l);n.texImage2D(s,0,u,i.width,i.height,0,c,l,null),e.bindFramebuffer(e.FRAMEBUFFER,t),e.framebufferTexture2D(e.FRAMEBUFFER,o,s,r.get(i.texture).__webglTexture,0),e.bindFramebuffer(e.FRAMEBUFFER,null)}function A(t,n,r){if(e.bindRenderbuffer(e.RENDERBUFFER,t),n.depthBuffer&&!n.stencilBuffer){if(r){var i=I(n);e.renderbufferStorageMultisample(e.RENDERBUFFER,i,e.DEPTH_COMPONENT16,n.width,n.height)}else e.renderbufferStorage(e.RENDERBUFFER,e.DEPTH_COMPONENT16,n.width,n.height);e.framebufferRenderbuffer(e.FRAMEBUFFER,e.DEPTH_ATTACHMENT,e.RENDERBUFFER,t)}else if(n.depthBuffer&&n.stencilBuffer){if(r){var i=I(n);e.renderbufferStorageMultisample(e.RENDERBUFFER,i,e.DEPTH_STENCIL,n.width,n.height)}else e.renderbufferStorage(e.RENDERBUFFER,e.DEPTH_STENCIL,n.width,n.height);e.framebufferRenderbuffer(e.FRAMEBUFFER,e.DEPTH_STENCIL_ATTACHMENT,e.RENDERBUFFER,t)}else{var o=g(a.convert(n.texture.format),a.convert(n.texture.type));if(r){var i=I(n);e.renderbufferStorageMultisample(e.RENDERBUFFER,i,o,n.width,n.height)}else e.renderbufferStorage(e.RENDERBUFFER,o,n.width,n.height)}e.bindRenderbuffer(e.RENDERBUFFER,null)}function j(t,n){if(n&&n.isWebGLRenderTargetCube)throw Error(`Depth Texture with cube render targets is not supported`);if(e.bindFramebuffer(e.FRAMEBUFFER,t),!(n.depthTexture&&n.depthTexture.isDepthTexture))throw Error(`renderTarget.depthTexture must be an instance of THREE.DepthTexture`);(!r.get(n.depthTexture).__webglTexture||n.depthTexture.image.width!==n.width||n.depthTexture.image.height!==n.height)&&(n.depthTexture.image.width=n.width,n.depthTexture.image.height=n.height,n.depthTexture.needsUpdate=!0),S(n.depthTexture,0);var i=r.get(n.depthTexture).__webglTexture;if(n.depthTexture.format===1026)e.framebufferTexture2D(e.FRAMEBUFFER,e.DEPTH_ATTACHMENT,e.TEXTURE_2D,i,0);else if(n.depthTexture.format===1027)e.framebufferTexture2D(e.FRAMEBUFFER,e.DEPTH_STENCIL_ATTACHMENT,e.TEXTURE_2D,i,0);else throw Error(`Unknown depthTexture format`)}function M(t){var n=r.get(t),i=t.isWebGLRenderTargetCube===!0;if(t.depthTexture){if(i)throw Error(`target.depthTexture not supported in Cube render targets`);j(n.__webglFramebuffer,t)}else if(i){n.__webglDepthbuffer=[];for(var a=0;a<6;a++)e.bindFramebuffer(e.FRAMEBUFFER,n.__webglFramebuffer[a]),n.__webglDepthbuffer[a]=e.createRenderbuffer(),A(n.__webglDepthbuffer[a],t)}else e.bindFramebuffer(e.FRAMEBUFFER,n.__webglFramebuffer),n.__webglDepthbuffer=e.createRenderbuffer(),A(n.__webglDepthbuffer,t);e.bindFramebuffer(e.FRAMEBUFFER,null)}function N(t){var s=r.get(t),c=r.get(t.texture);t.addEventListener(`dispose`,y),c.__webglTexture=e.createTexture(),o.memory.textures++;var l=t.isWebGLRenderTargetCube===!0,u=t.isWebGLMultisampleRenderTarget===!0,f=d(t);if(l){s.__webglFramebuffer=[];for(var p=0;p<6;p++)s.__webglFramebuffer[p]=e.createFramebuffer()}else if(s.__webglFramebuffer=e.createFramebuffer(),u)if(i.isWebGL2){s.__webglMultisampledFramebuffer=e.createFramebuffer(),s.__webglColorRenderbuffer=e.createRenderbuffer(),e.bindRenderbuffer(e.RENDERBUFFER,s.__webglColorRenderbuffer);var _=g(a.convert(t.texture.format),a.convert(t.texture.type)),v=I(t);e.renderbufferStorageMultisample(e.RENDERBUFFER,v,_,t.width,t.height),e.bindFramebuffer(e.FRAMEBUFFER,s.__webglMultisampledFramebuffer),e.framebufferRenderbuffer(e.FRAMEBUFFER,e.COLOR_ATTACHMENT0,e.RENDERBUFFER,s.__webglColorRenderbuffer),e.bindRenderbuffer(e.RENDERBUFFER,null),t.depthBuffer&&(s.__webglDepthRenderbuffer=e.createRenderbuffer(),A(s.__webglDepthRenderbuffer,t,!0)),e.bindFramebuffer(e.FRAMEBUFFER,null)}else console.warn(`THREE.WebGLRenderer: WebGLMultisampleRenderTarget can only be used with WebGL2.`);if(l){n.bindTexture(e.TEXTURE_CUBE_MAP,c.__webglTexture),D(e.TEXTURE_CUBE_MAP,t.texture,f);for(var p=0;p<6;p++)k(s.__webglFramebuffer[p],t,e.COLOR_ATTACHMENT0,e.TEXTURE_CUBE_MAP_POSITIVE_X+p);m(t.texture,f)&&h(e.TEXTURE_CUBE_MAP,t.texture,t.width,t.height),n.bindTexture(e.TEXTURE_CUBE_MAP,null)}else n.bindTexture(e.TEXTURE_2D,c.__webglTexture),D(e.TEXTURE_2D,t.texture,f),k(s.__webglFramebuffer,t,e.COLOR_ATTACHMENT0,e.TEXTURE_2D),m(t.texture,f)&&h(e.TEXTURE_2D,t.texture,t.width,t.height),n.bindTexture(e.TEXTURE_2D,null);t.depthBuffer&&M(t)}function P(t){var i=t.texture;if(m(i,d(t))){var a=t.isWebGLRenderTargetCube?e.TEXTURE_CUBE_MAP:e.TEXTURE_2D,o=r.get(i).__webglTexture;n.bindTexture(a,o),h(a,i,t.width,t.height),n.bindTexture(a,null)}}function F(t){if(t.isWebGLMultisampleRenderTarget)if(i.isWebGL2){var n=r.get(t);e.bindFramebuffer(e.READ_FRAMEBUFFER,n.__webglMultisampledFramebuffer),e.bindFramebuffer(e.DRAW_FRAMEBUFFER,n.__webglFramebuffer);var a=t.width,o=t.height,s=e.COLOR_BUFFER_BIT;t.depthBuffer&&(s|=e.DEPTH_BUFFER_BIT),t.stencilBuffer&&(s|=e.STENCIL_BUFFER_BIT),e.blitFramebuffer(0,0,a,o,0,0,a,o,s,e.NEAREST)}else console.warn(`THREE.WebGLRenderer: WebGLMultisampleRenderTarget can only be used with WebGL2.`)}function I(e){return i.isWebGL2&&e.isWebGLMultisampleRenderTarget?Math.min(i.maxSamples,e.samples):0}function L(e){var t=e.id,n=o.render.frame;s[t]!==n&&(s[t]=n,e.update())}this.setTexture2D=S,this.setTexture3D=C,this.setTextureCube=T,this.setTextureCubeDynamic=E,this.setupRenderTarget=N,this.updateRenderTargetMipmap=P,this.updateMultisampleRenderTarget=F}function gn(e,t,n){function r(r){var i;if(r===1e3)return e.REPEAT;if(r===1001)return e.CLAMP_TO_EDGE;if(r===1002)return e.MIRRORED_REPEAT;if(r===1003)return e.NEAREST;if(r===1004)return e.NEAREST_MIPMAP_NEAREST;if(r===1005)return e.NEAREST_MIPMAP_LINEAR;if(r===1006)return e.LINEAR;if(r===1007)return e.LINEAR_MIPMAP_NEAREST;if(r===1008)return e.LINEAR_MIPMAP_LINEAR;if(r===1009)return e.UNSIGNED_BYTE;if(r===1017)return e.UNSIGNED_SHORT_4_4_4_4;if(r===1018)return e.UNSIGNED_SHORT_5_5_5_1;if(r===1019)return e.UNSIGNED_SHORT_5_6_5;if(r===1010)return e.BYTE;if(r===1011)return e.SHORT;if(r===1012)return e.UNSIGNED_SHORT;if(r===1013)return e.INT;if(r===1014)return e.UNSIGNED_INT;if(r===1015)return e.FLOAT;if(r===1016){if(n.isWebGL2)return e.HALF_FLOAT;if(i=t.get(`OES_texture_half_float`),i!==null)return i.HALF_FLOAT_OES}if(r===1021)return e.ALPHA;if(r===1022)return e.RGB;if(r===1023)return e.RGBA;if(r===1024)return e.LUMINANCE;if(r===1025)return e.LUMINANCE_ALPHA;if(r===1026)return e.DEPTH_COMPONENT;if(r===1027)return e.DEPTH_STENCIL;if(r===1028)return e.RED;if(r===100)return e.FUNC_ADD;if(r===101)return e.FUNC_SUBTRACT;if(r===102)return e.FUNC_REVERSE_SUBTRACT;if(r===200)return e.ZERO;if(r===201)return e.ONE;if(r===202)return e.SRC_COLOR;if(r===203)return e.ONE_MINUS_SRC_COLOR;if(r===204)return e.SRC_ALPHA;if(r===205)return e.ONE_MINUS_SRC_ALPHA;if(r===206)return e.DST_ALPHA;if(r===207)return e.ONE_MINUS_DST_ALPHA;if(r===208)return e.DST_COLOR;if(r===209)return e.ONE_MINUS_DST_COLOR;if(r===210)return e.SRC_ALPHA_SATURATE;if((r===33776||r===33777||r===33778||r===33779)&&(i=t.get(`WEBGL_compressed_texture_s3tc`),i!==null)){if(r===33776)return i.COMPRESSED_RGB_S3TC_DXT1_EXT;if(r===33777)return i.COMPRESSED_RGBA_S3TC_DXT1_EXT;if(r===33778)return i.COMPRESSED_RGBA_S3TC_DXT3_EXT;if(r===33779)return i.COMPRESSED_RGBA_S3TC_DXT5_EXT}if((r===35840||r===35841||r===35842||r===35843)&&(i=t.get(`WEBGL_compressed_texture_pvrtc`),i!==null)){if(r===35840)return i.COMPRESSED_RGB_PVRTC_4BPPV1_IMG;if(r===35841)return i.COMPRESSED_RGB_PVRTC_2BPPV1_IMG;if(r===35842)return i.COMPRESSED_RGBA_PVRTC_4BPPV1_IMG;if(r===35843)return i.COMPRESSED_RGBA_PVRTC_2BPPV1_IMG}if(r===36196&&(i=t.get(`WEBGL_compressed_texture_etc1`),i!==null))return i.COMPRESSED_RGB_ETC1_WEBGL;if((r===37808||r===37809||r===37810||r===37811||r===37812||r===37813||r===37814||r===37815||r===37816||r===37817||r===37818||r===37819||r===37820||r===37821)&&(i=t.get(`WEBGL_compressed_texture_astc`),i!==null))return r;if(r===103||r===104){if(n.isWebGL2){if(r===103)return e.MIN;if(r===104)return e.MAX}if(i=t.get(`EXT_blend_minmax`),i!==null){if(r===103)return i.MIN_EXT;if(r===104)return i.MAX_EXT}}if(r===1020){if(n.isWebGL2)return e.UNSIGNED_INT_24_8;if(i=t.get(`WEBGL_depth_texture`),i!==null)return i.UNSIGNED_INT_24_8_WEBGL}return 0}return{convert:r}}function _n(){z.call(this),this.type=`Group`}_n.prototype=Object.assign(Object.create(z.prototype),{constructor:_n,isGroup:!0});function vn(e,t,n,r){he.call(this),this.type=`PerspectiveCamera`,this.fov=e===void 0?50:e,this.zoom=1,this.near=n===void 0?.1:n,this.far=r===void 0?2e3:r,this.focus=10,this.aspect=t===void 0?1:t,this.view=null,this.filmGauge=35,this.filmOffset=0,this.updateProjectionMatrix()}vn.prototype=Object.assign(Object.create(he.prototype),{constructor:vn,isPerspectiveCamera:!0,copy:function(e,t){return he.prototype.copy.call(this,e,t),this.fov=e.fov,this.zoom=e.zoom,this.near=e.near,this.far=e.far,this.focus=e.focus,this.aspect=e.aspect,this.view=e.view===null?null:Object.assign({},e.view),this.filmGauge=e.filmGauge,this.filmOffset=e.filmOffset,this},setFocalLength:function(e){var t=.5*this.getFilmHeight()/e;this.fov=w.RAD2DEG*2*Math.atan(t),this.updateProjectionMatrix()},getFocalLength:function(){var e=Math.tan(w.DEG2RAD*.5*this.fov);return .5*this.getFilmHeight()/e},getEffectiveFOV:function(){return w.RAD2DEG*2*Math.atan(Math.tan(w.DEG2RAD*.5*this.fov)/this.zoom)},getFilmWidth:function(){return this.filmGauge*Math.min(this.aspect,1)},getFilmHeight:function(){return this.filmGauge/Math.max(this.aspect,1)},setViewOffset:function(e,t,n,r,i,a){this.aspect=e/t,this.view===null&&(this.view={enabled:!0,fullWidth:1,fullHeight:1,offsetX:0,offsetY:0,width:1,height:1}),this.view.enabled=!0,this.view.fullWidth=e,this.view.fullHeight=t,this.view.offsetX=n,this.view.offsetY=r,this.view.width=i,this.view.height=a,this.updateProjectionMatrix()},clearViewOffset:function(){this.view!==null&&(this.view.enabled=!1),this.updateProjectionMatrix()},updateProjectionMatrix:function(){var e=this.near,t=e*Math.tan(w.DEG2RAD*.5*this.fov)/this.zoom,n=2*t,r=this.aspect*n,i=-.5*r,a=this.view;if(this.view!==null&&this.view.enabled){var o=a.fullWidth,s=a.fullHeight;i+=a.offsetX*r/o,t-=a.offsetY*n/s,r*=a.width/o,n*=a.height/s}var c=this.filmOffset;c!==0&&(i+=e*c/this.getFilmWidth()),this.projectionMatrix.makePerspective(i,i+r,t,t-n,e,this.far),this.projectionMatrixInverse.getInverse(this.projectionMatrix)},toJSON:function(e){var t=z.prototype.toJSON.call(this,e);return t.object.fov=this.fov,t.object.zoom=this.zoom,t.object.near=this.near,t.object.far=this.far,t.object.focus=this.focus,t.object.aspect=this.aspect,this.view!==null&&(t.object.view=Object.assign({},this.view)),t.object.filmGauge=this.filmGauge,t.object.filmOffset=this.filmOffset,t}});function yn(e){vn.call(this),this.cameras=e||[]}yn.prototype=Object.assign(Object.create(vn.prototype),{constructor:yn,isArrayCamera:!0});var bn=new O,xn=new O;function Sn(e,t,n){bn.setFromMatrixPosition(t.matrixWorld),xn.setFromMatrixPosition(n.matrixWorld);var r=bn.distanceTo(xn),i=t.projectionMatrix.elements,a=n.projectionMatrix.elements,o=i[14]/(i[10]-1),s=i[14]/(i[10]+1),c=(i[9]+1)/i[5],l=(i[9]-1)/i[5],u=(i[8]-1)/i[0],d=(a[8]+1)/a[0],f=o*u,p=o*d,m=r/(-u+d),h=m*-u;t.matrixWorld.decompose(e.position,e.quaternion,e.scale),e.translateX(h),e.translateZ(m),e.matrixWorld.compose(e.position,e.quaternion,e.scale),e.matrixWorldInverse.getInverse(e.matrixWorld);var g=o+m,_=s+m,v=f-h,y=p+(r-h),b=c*s/_*g,x=l*s/_*g;e.projectionMatrix.makePerspective(v,y,b,x,g,_)}function Cn(e){var t=this,n=null,r=null,i=null,a=[],o=new E,s=new E,c=1,l=`stage`;typeof window<`u`&&`VRFrameData`in window&&(r=new window.VRFrameData,window.addEventListener(`vrdisplaypresentchange`,y,!1));var u=new E,d=new D,f=new O,p=new vn;p.bounds=new K(0,0,.5,1),p.layers.enable(1);var m=new vn;m.bounds=new K(.5,0,.5,1),m.layers.enable(2);var h=new yn([p,m]);h.layers.enable(1),h.layers.enable(2);function g(){return n!==null&&n.isPresenting===!0}var _,v;function y(){if(g()){var r=n.getEyeParameters(`left`),i=r.renderWidth*c,a=r.renderHeight*c;v=e.getPixelRatio(),_=e.getSize(),e.setDrawingBufferSize(i*2,a,1),C.start()}else t.enabled&&e.setDrawingBufferSize(_.width,_.height,v),C.stop()}var b=[];function x(e){for(var t=navigator.getGamepads&&navigator.getGamepads(),n=0,r=0,i=t.length;n<i;n++){var a=t[n];if(a&&(a.id===`Daydream Controller`||a.id===`Gear VR Controller`||a.id===`Oculus Go Controller`||a.id===`OpenVR Gamepad`||a.id.startsWith(`Oculus Touch`)||a.id.startsWith(`Spatial Controller`))){if(r===e)return a;r++}}}function S(){for(var e=0;e<a.length;e++){var t=a[e],n=x(e);if(n!==void 0&&n.pose!==void 0){if(n.pose===null)return;var r=n.pose;r.hasPosition===!1&&t.position.set(.2,-.6,-.05),r.position!==null&&t.position.fromArray(r.position),r.orientation!==null&&t.quaternion.fromArray(r.orientation),t.matrix.compose(t.position,t.quaternion,t.scale),t.matrix.premultiply(o),t.matrix.decompose(t.position,t.quaternion,t.scale),t.matrixWorldNeedsUpdate=!0,t.visible=!0;var i=n.id===`Daydream Controller`?0:1;b[e]!==n.buttons[i].pressed&&(b[e]=n.buttons[i].pressed,b[e]===!0?t.dispatchEvent({type:`selectstart`}):(t.dispatchEvent({type:`selectend`}),t.dispatchEvent({type:`select`})))}else t.visible=!1}}this.enabled=!1,this.getController=function(e){var t=a[e];return t===void 0&&(t=new _n,t.matrixAutoUpdate=!1,t.visible=!1,a[e]=t),t},this.getDevice=function(){return n},this.setDevice=function(e){e!==void 0&&(n=e),C.setContext(e)},this.setFramebufferScaleFactor=function(e){c=e},this.setFrameOfReferenceType=function(e){l=e},this.setPoseTarget=function(e){e!==void 0&&(i=e)},this.getCamera=function(e){var t=l===`stage`?1.6:0;if(n===null)return e.position.set(0,t,0),e;if(n.depthNear=e.near,n.depthFar=e.far,n.getFrameData(r),l===`stage`){var a=n.stageParameters;a?o.fromArray(a.sittingToStandingTransform):o.makeTranslation(0,t,0)}var c=r.pose,g=i===null?e:i;if(g.matrix.copy(o),g.matrix.decompose(g.position,g.quaternion,g.scale),c.orientation!==null&&(d.fromArray(c.orientation),g.quaternion.multiply(d)),c.position!==null&&(d.setFromRotationMatrix(o),f.fromArray(c.position),f.applyQuaternion(d),g.position.add(f)),g.updateMatrixWorld(),n.isPresenting===!1)return e;p.near=e.near,m.near=e.near,p.far=e.far,m.far=e.far,p.matrixWorldInverse.fromArray(r.leftViewMatrix),m.matrixWorldInverse.fromArray(r.rightViewMatrix),s.getInverse(o),l===`stage`&&(p.matrixWorldInverse.multiply(s),m.matrixWorldInverse.multiply(s));var _=g.parent;_!==null&&(u.getInverse(_.matrixWorld),p.matrixWorldInverse.multiply(u),m.matrixWorldInverse.multiply(u)),p.matrixWorld.getInverse(p.matrixWorldInverse),m.matrixWorld.getInverse(m.matrixWorldInverse),p.projectionMatrix.fromArray(r.leftProjectionMatrix),m.projectionMatrix.fromArray(r.rightProjectionMatrix),Sn(h,p,m);var v=n.getLayers();if(v.length){var y=v[0];y.leftBounds!==null&&y.leftBounds.length===4&&p.bounds.fromArray(y.leftBounds),y.rightBounds!==null&&y.rightBounds.length===4&&m.bounds.fromArray(y.rightBounds)}return S(),h},this.getStandingMatrix=function(){return o},this.isPresenting=g;var C=new Ae;this.setAnimationLoop=function(e){C.setAnimationLoop(e)},this.submitFrame=function(){g()&&n.submitFrame()},this.dispose=function(){typeof window<`u`&&window.removeEventListener(`vrdisplaypresentchange`,y)}}function wn(e){var t=e.context,n=null,r=null,i=1,a=null,o=`stage`,s=null,c=[],l=[];function u(){return r!==null&&a!==null}var d=new vn;d.layers.enable(1),d.viewport=new K;var f=new vn;f.layers.enable(2),f.viewport=new K;var p=new yn([d,f]);p.layers.enable(1),p.layers.enable(2),this.enabled=!1,this.getController=function(e){var t=c[e];return t===void 0&&(t=new _n,t.matrixAutoUpdate=!1,t.visible=!1,c[e]=t),t},this.getDevice=function(){return n},this.setDevice=function(e){e!==void 0&&(n=e),e instanceof XRDevice&&t.setCompatibleXRDevice(e)};function m(e){var t=c[l.indexOf(e.inputSource)];t&&t.dispatchEvent({type:e.type})}function h(){e.setFramebuffer(null),y.stop()}this.setFramebufferScaleFactor=function(e){i=e},this.setFrameOfReferenceType=function(e){o=e},this.setSession=function(n){r=n,r!==null&&(r.addEventListener(`select`,m),r.addEventListener(`selectstart`,m),r.addEventListener(`selectend`,m),r.addEventListener(`end`,h),r.baseLayer=new XRWebGLLayer(r,t,{framebufferScaleFactor:i}),r.requestFrameOfReference(o).then(function(t){a=t,e.setFramebuffer(r.baseLayer.framebuffer),y.setContext(r),y.start()}),l=r.getInputSources(),r.addEventListener(`inputsourceschange`,function(){l=r.getInputSources(),console.log(l);for(var e=0;e<c.length;e++){var t=c[e];t.userData.inputSource=l[e]}}))};function g(e,t){t===null?e.matrixWorld.copy(e.matrix):e.matrixWorld.multiplyMatrices(t.matrixWorld,e.matrix),e.matrixWorldInverse.getInverse(e.matrixWorld)}this.getCamera=function(e){if(u()){var t=e.parent,n=p.cameras;g(p,t);for(var r=0;r<n.length;r++)g(n[r],t);e.matrixWorld.copy(p.matrixWorld);for(var i=e.children,r=0,a=i.length;r<a;r++)i[r].updateMatrixWorld(!0);return Sn(p,d,f),p}return e},this.isPresenting=u;var _=null;function v(e,t){if(s=t.getDevicePose(a),s!==null)for(var n=r.baseLayer,i=t.views,o=0;o<i.length;o++){var u=i[o],d=n.getViewport(u),f=s.getViewMatrix(u),m=p.cameras[o];m.matrix.fromArray(f).getInverse(m.matrix),m.projectionMatrix.fromArray(u.projectionMatrix),m.viewport.set(d.x,d.y,d.width,d.height),o===0&&p.matrix.copy(m.matrix)}for(var o=0;o<c.length;o++){var h=c[o],g=l[o];if(g){var v=t.getInputPose(g,a);if(v!==null){`targetRay`in v?h.matrix.elements=v.targetRay.transformMatrix:`pointerMatrix`in v&&(h.matrix.elements=v.pointerMatrix),h.matrix.decompose(h.position,h.rotation,h.scale),h.visible=!0;continue}}h.visible=!1}_&&_(e)}var y=new Ae;y.setAnimationLoop(v),this.setAnimationLoop=function(e){_=e},this.dispose=function(){},this.getStandingMatrix=function(){return console.warn(`THREE.WebXRManager: getStandingMatrix() is no longer needed.`),new THREE.Matrix4},this.submitFrame=function(){}}function Tn(e){e||={};var t=e.canvas===void 0?document.createElementNS(`http://www.w3.org/1999/xhtml`,`canvas`):e.canvas,n=e.context===void 0?null:e.context,r=e.alpha!==void 0&&e.alpha,i=e.depth===void 0||e.depth,a=e.stencil===void 0||e.stencil,o=e.antialias!==void 0&&e.antialias,s=e.premultipliedAlpha===void 0||e.premultipliedAlpha,c=e.preserveDrawingBuffer!==void 0&&e.preserveDrawingBuffer,l=e.powerPreference===void 0?`default`:e.powerPreference,u=null,f=null;this.domElement=t,this.context=null,this.autoClear=!0,this.autoClearColor=!0,this.autoClearDepth=!0,this.autoClearStencil=!0,this.sortObjects=!0,this.clippingPlanes=[],this.localClippingEnabled=!1,this.gammaFactor=2,this.gammaInput=!1,this.gammaOutput=!1,this.physicallyCorrectLights=!1,this.toneMapping=1,this.toneMappingExposure=1,this.toneMappingWhitePoint=1,this.maxMorphTargets=8,this.maxMorphNormals=4;var p=this,h=!1,g=null,_=null,v=null,y=-1,b={geometry:null,program:null,wireframe:!1},x=null,S=null,C=new K,T=new K,D=null,k=0,A=t.width,j=t.height,M=1,N=new K(0,0,A,j),P=new K(0,0,A,j),F=!1,I=new Oe,L=new Le,R=!1,ee=!1,te=new E,z=new O;function ne(){return _===null?M:1}var B;try{var V={alpha:r,depth:i,stencil:a,antialias:o,premultipliedAlpha:s,preserveDrawingBuffer:c,powerPreference:l};if(t.addEventListener(`webglcontextlost`,ge,!1),t.addEventListener(`webglcontextrestored`,_e,!1),B=n||t.getContext(`webgl`,V)||t.getContext(`experimental-webgl`,V),B===null)throw t.getContext(`webgl`)===null?Error(`Error creating WebGL context.`):Error(`Error creating WebGL context with your selected attributes.`);B.getShaderPrecisionFormat===void 0&&(B.getShaderPrecisionFormat=function(){return{rangeMin:1,rangeMax:1,precision:1}})}catch(e){console.error(`THREE.WebGLRenderer: `+e.message)}var H,U,W,G,q,re,ie,ae,oe,J,se,ce,Y,le,ue,de,fe;function pe(){H=new Re(B),U=new Ie(B,H,e),U.isWebGL2||(H.get(`WEBGL_depth_texture`),H.get(`OES_texture_float`),H.get(`OES_texture_half_float`),H.get(`OES_texture_half_float_linear`),H.get(`OES_standard_derivatives`),H.get(`OES_element_index_uint`),H.get(`ANGLE_instanced_arrays`)),H.get(`OES_texture_float_linear`),fe=new gn(B,H,U),W=new mn(B,H,fe,U),W.scissor(T.copy(P).multiplyScalar(M)),W.viewport(C.copy(N).multiplyScalar(M)),G=new Ve(B),q=new en,re=new hn(B,H,W,q,U,fe,G),ie=new je(B),ae=new ze(B,ie,G),oe=new We(ae,G),le=new Ue(B),J=new $t(p,H,U),se=new an,ce=new un,Y=new Pe(p,W,oe,s),ue=new Fe(B,H,G,U),de=new Be(B,H,G,U),G.programs=J.programs,p.context=B,p.capabilities=U,p.extensions=H,p.properties=q,p.renderLists=se,p.state=W,p.info=G}pe();var me=null;typeof navigator<`u`&&(me=`xr`in navigator?new wn(p):new Cn(p)),this.vr=me;var he=new pn(p,oe,U.maxTextureSize);this.shadowMap=he,this.getContext=function(){return B},this.getContextAttributes=function(){return B.getContextAttributes()},this.forceContextLoss=function(){var e=H.get(`WEBGL_lose_context`);e&&e.loseContext()},this.forceContextRestore=function(){var e=H.get(`WEBGL_lose_context`);e&&e.restoreContext()},this.getPixelRatio=function(){return M},this.setPixelRatio=function(e){e!==void 0&&(M=e,this.setSize(A,j,!1))},this.getSize=function(){return{width:A,height:j}},this.setSize=function(e,n,r){if(me.isPresenting()){console.warn(`THREE.WebGLRenderer: Can't change size while VR device is presenting.`);return}A=e,j=n,t.width=e*M,t.height=n*M,r!==!1&&(t.style.width=e+`px`,t.style.height=n+`px`),this.setViewport(0,0,e,n)},this.getDrawingBufferSize=function(){return{width:A*M,height:j*M}},this.setDrawingBufferSize=function(e,n,r){A=e,j=n,M=r,t.width=e*r,t.height=n*r,this.setViewport(0,0,e,n)},this.getCurrentViewport=function(){return C},this.setViewport=function(e,t,n,r){N.set(e,j-t-r,n,r),W.viewport(C.copy(N).multiplyScalar(M))},this.setScissor=function(e,t,n,r){P.set(e,j-t-r,n,r),W.scissor(T.copy(P).multiplyScalar(M))},this.setScissorTest=function(e){W.setScissorTest(F=e)},this.getClearColor=function(){return Y.getClearColor()},this.setClearColor=function(){Y.setClearColor.apply(Y,arguments)},this.getClearAlpha=function(){return Y.getClearAlpha()},this.setClearAlpha=function(){Y.setClearAlpha.apply(Y,arguments)},this.clear=function(e,t,n){var r=0;(e===void 0||e)&&(r|=B.COLOR_BUFFER_BIT),(t===void 0||t)&&(r|=B.DEPTH_BUFFER_BIT),(n===void 0||n)&&(r|=B.STENCIL_BUFFER_BIT),B.clear(r)},this.clearColor=function(){this.clear(!0,!1,!1)},this.clearDepth=function(){this.clear(!1,!0,!1)},this.clearStencil=function(){this.clear(!1,!1,!0)},this.dispose=function(){t.removeEventListener(`webglcontextlost`,ge,!1),t.removeEventListener(`webglcontextrestored`,_e,!1),se.dispose(),ce.dispose(),q.dispose(),oe.dispose(),me.dispose(),De.stop()};function ge(e){e.preventDefault(),console.log(`THREE.WebGLRenderer: Context Lost.`),h=!0}function _e(){console.log(`THREE.WebGLRenderer: Context Restored.`),h=!1,pe()}function ve(e){var t=e.target;t.removeEventListener(`dispose`,ve),ye(t)}function ye(e){be(e),q.remove(e)}function be(e){var t=q.get(e).program;e.program=void 0,t!==void 0&&J.releaseProgram(t)}function xe(e,t){e.render(function(e){p.renderBufferImmediate(e,t)})}this.renderBufferImmediate=function(e,t){W.initAttributes();var n=q.get(e);e.hasPositions&&!n.position&&(n.position=B.createBuffer()),e.hasNormals&&!n.normal&&(n.normal=B.createBuffer()),e.hasUvs&&!n.uv&&(n.uv=B.createBuffer()),e.hasColors&&!n.color&&(n.color=B.createBuffer());var r=t.getAttributes();e.hasPositions&&(B.bindBuffer(B.ARRAY_BUFFER,n.position),B.bufferData(B.ARRAY_BUFFER,e.positionArray,B.DYNAMIC_DRAW),W.enableAttribute(r.position),B.vertexAttribPointer(r.position,3,B.FLOAT,!1,0,0)),e.hasNormals&&(B.bindBuffer(B.ARRAY_BUFFER,n.normal),B.bufferData(B.ARRAY_BUFFER,e.normalArray,B.DYNAMIC_DRAW),W.enableAttribute(r.normal),B.vertexAttribPointer(r.normal,3,B.FLOAT,!1,0,0)),e.hasUvs&&(B.bindBuffer(B.ARRAY_BUFFER,n.uv),B.bufferData(B.ARRAY_BUFFER,e.uvArray,B.DYNAMIC_DRAW),W.enableAttribute(r.uv),B.vertexAttribPointer(r.uv,2,B.FLOAT,!1,0,0)),e.hasColors&&(B.bindBuffer(B.ARRAY_BUFFER,n.color),B.bufferData(B.ARRAY_BUFFER,e.colorArray,B.DYNAMIC_DRAW),W.enableAttribute(r.color),B.vertexAttribPointer(r.color,3,B.FLOAT,!1,0,0)),W.disableUnusedAttributes(),B.drawArrays(B.TRIANGLES,0,e.count),e.count=0},this.renderBufferDirect=function(e,t,n,r,i,a){var o=i.isMesh&&i.normalMatrix.determinant()<0;W.setMaterial(r,o);var s=Ge(e,t,r,i),c=!1;(b.geometry!==n.id||b.program!==s.id||b.wireframe!==(r.wireframe===!0))&&(b.geometry=n.id,b.program=s.id,b.wireframe=r.wireframe===!0,c=!0),i.morphTargetInfluences&&(le.update(i,n,r,s),c=!0);var l=n.index,u=n.attributes.position,d=1;r.wireframe===!0&&(l=ae.getWireframeAttribute(n),d=2);var f,p=ue;l!==null&&(f=ie.get(l),p=de,p.setIndex(f)),c&&(Ce(r,s,n),l!==null&&B.bindBuffer(B.ELEMENT_ARRAY_BUFFER,f.buffer));var m=1/0;l===null?u!==void 0&&(m=u.count):m=l.count;var h=n.drawRange.start*d,g=n.drawRange.count*d,_=a===null?0:a.start*d,v=a===null?1/0:a.count*d,y=Math.max(h,_),x=Math.min(m,h+g,_+v)-1,S=Math.max(0,x-y+1);if(S!==0){if(i.isMesh)if(r.wireframe===!0)W.setLineWidth(r.wireframeLinewidth*ne()),p.setMode(B.LINES);else switch(i.drawMode){case 0:p.setMode(B.TRIANGLES);break;case 1:p.setMode(B.TRIANGLE_STRIP);break;case 2:p.setMode(B.TRIANGLE_FAN);break}else if(i.isLine){var C=r.linewidth;C===void 0&&(C=1),W.setLineWidth(C*ne()),i.isLineSegments?p.setMode(B.LINES):i.isLineLoop?p.setMode(B.LINE_LOOP):p.setMode(B.LINE_STRIP)}else i.isPoints?p.setMode(B.POINTS):i.isSprite&&p.setMode(B.TRIANGLES);n&&n.isInstancedBufferGeometry?n.maxInstancedCount>0&&p.renderInstances(n,y,S):p.render(y,S)}};function Ce(e,t,n){if(n&&n.isInstancedBufferGeometry&!U.isWebGL2&&H.get(`ANGLE_instanced_arrays`)===null){console.error(`THREE.WebGLRenderer.setupVertexAttributes: using THREE.InstancedBufferGeometry but hardware does not support extension ANGLE_instanced_arrays.`);return}W.initAttributes();var r=n.attributes,i=t.getAttributes(),a=e.defaultAttributeValues;for(var o in i){var s=i[o];if(s>=0){var c=r[o];if(c!==void 0){var l=c.normalized,u=c.itemSize,d=ie.get(c);if(d===void 0)continue;var f=d.buffer,p=d.type,m=d.bytesPerElement;if(c.isInterleavedBufferAttribute){var h=c.data,g=h.stride,_=c.offset;h&&h.isInstancedInterleavedBuffer?(W.enableAttributeAndDivisor(s,h.meshPerAttribute),n.maxInstancedCount===void 0&&(n.maxInstancedCount=h.meshPerAttribute*h.count)):W.enableAttribute(s),B.bindBuffer(B.ARRAY_BUFFER,f),B.vertexAttribPointer(s,u,p,l,g*m,_*m)}else c.isInstancedBufferAttribute?(W.enableAttributeAndDivisor(s,c.meshPerAttribute),n.maxInstancedCount===void 0&&(n.maxInstancedCount=c.meshPerAttribute*c.count)):W.enableAttribute(s),B.bindBuffer(B.ARRAY_BUFFER,f),B.vertexAttribPointer(s,u,p,l,0,0)}else if(a!==void 0){var v=a[o];if(v!==void 0)switch(v.length){case 2:B.vertexAttrib2fv(s,v);break;case 3:B.vertexAttrib3fv(s,v);break;case 4:B.vertexAttrib4fv(s,v);break;default:B.vertexAttrib1fv(s,v)}}}}W.disableUnusedAttributes()}this.compile=function(e,t){f=ce.get(e,t),f.init(),e.traverse(function(e){e.isLight&&(f.pushLight(e),e.castShadow&&f.pushShadow(e))}),f.setupLights(t),e.traverse(function(t){if(t.material)if(Array.isArray(t.material))for(var n=0;n<t.material.length;n++)He(t.material[n],e.fog,t);else He(t.material,e.fog,t)})};var we=null;function Te(e){me.isPresenting()||we&&we(e)}var De=new Ae;De.setAnimationLoop(Te),typeof window<`u`&&De.setContext(window),this.setAnimationLoop=function(e){we=e,me.setAnimationLoop(e),De.start()},this.render=function(e,t,n,r){if(!(t&&t.isCamera)){console.error(`THREE.WebGLRenderer.render: camera is not an instance of THREE.Camera.`);return}if(!h){b.geometry=null,b.program=null,b.wireframe=!1,y=-1,x=null,e.autoUpdate===!0&&e.updateMatrixWorld(),t.parent===null&&t.updateMatrixWorld(),me.enabled&&(t=me.getCamera(t)),f=ce.get(e,t),f.init(),e.onBeforeRender(p,e,t,n),te.multiplyMatrices(t.projectionMatrix,t.matrixWorldInverse),I.setFromMatrix(te),ee=this.localClippingEnabled,R=L.init(this.clippingPlanes,ee,t),u=se.get(e,t),u.init(),X(e,t,0,p.sortObjects),p.sortObjects===!0&&u.sort(),R&&L.beginShadows();var i=f.state.shadowsArray;he.render(i,e,t),f.setupLights(t),R&&L.endShadows(),this.info.autoReset&&this.info.reset(),n===void 0&&(n=null),this.setRenderTarget(n),Y.render(u,e,t,r);var a=u.opaque,o=u.transparent;if(e.overrideMaterial){var s=e.overrideMaterial;a.length&&Me(a,e,t,s),o.length&&Me(o,e,t,s)}else a.length&&Me(a,e,t),o.length&&Me(o,e,t);n&&(re.updateRenderTargetMipmap(n),re.updateMultisampleRenderTarget(n)),W.buffers.depth.setTest(!0),W.buffers.depth.setMask(!0),W.buffers.color.setMask(!0),W.setPolygonOffset(!1),e.onAfterRender(p,e,t),me.enabled&&me.submitFrame(),u=null,f=null}};function X(e,t,n,r){if(e.visible!==!1){if(e.layers.test(t.layers)){if(e.isGroup)n=e.renderOrder;else if(e.isLight)f.pushLight(e),e.castShadow&&f.pushShadow(e);else if(e.isSprite){if(!e.frustumCulled||I.intersectsSprite(e)){r&&z.setFromMatrixPosition(e.matrixWorld).applyMatrix4(te);var i=oe.update(e),a=e.material;u.push(e,i,a,n,z.z,null)}}else if(e.isImmediateRenderObject)r&&z.setFromMatrixPosition(e.matrixWorld).applyMatrix4(te),u.push(e,null,e.material,n,z.z,null);else if((e.isMesh||e.isLine||e.isPoints)&&(e.isSkinnedMesh&&e.skeleton.update(),!e.frustumCulled||I.intersectsObject(e))){r&&z.setFromMatrixPosition(e.matrixWorld).applyMatrix4(te);var i=oe.update(e),a=e.material;if(Array.isArray(a))for(var o=i.groups,s=0,c=o.length;s<c;s++){var l=o[s],d=a[l.materialIndex];d&&d.visible&&u.push(e,i,d,n,z.z,l)}else a.visible&&u.push(e,i,a,n,z.z,null)}}for(var p=e.children,s=0,c=p.length;s<c;s++)X(p[s],t,n,r)}}function Me(e,t,n,r){for(var i=0,a=e.length;i<a;i++){var o=e[i],s=o.object,c=o.geometry,l=r===void 0?o.material:r,u=o.group;if(n.isArrayCamera){S=n;for(var d=n.cameras,p=0,m=d.length;p<m;p++){var h=d[p];if(s.layers.test(h.layers)){if(`viewport`in h)W.viewport(C.copy(h.viewport));else{var g=h.bounds,_=g.x*A,v=g.y*j,y=g.z*A,b=g.w*j;W.viewport(C.set(_,v,y,b).multiplyScalar(M))}f.setupLights(h),Ne(s,t,h,c,l,u)}}}else S=null,Ne(s,t,n,c,l,u)}}function Ne(e,t,n,r,i,a){if(e.onBeforeRender(p,t,n,r,i,a),f=ce.get(t,S||n),e.modelViewMatrix.multiplyMatrices(n.matrixWorldInverse,e.matrixWorld),e.normalMatrix.getNormalMatrix(e.modelViewMatrix),e.isImmediateRenderObject){W.setMaterial(i);var o=Ge(n,t.fog,i,e);b.geometry=null,b.program=null,b.wireframe=!1,xe(e,o)}else p.renderBufferDirect(n,t.fog,r,i,e,a);e.onAfterRender(p,t,n,r,i,a),f=ce.get(t,S||n)}function He(e,t,n){var r=q.get(e),i=f.state.lights,a=f.state.shadowsArray,o=r.lightsHash,s=i.state.hash,c=J.getParameters(e,i.state,a,t,L.numPlanes,L.numIntersection,n),l=J.getProgramCode(e,c),u=r.program,d=!0;if(u===void 0)e.addEventListener(`dispose`,ve);else if(u.code!==l)be(e);else if(o.stateID!==s.stateID||o.directionalLength!==s.directionalLength||o.pointLength!==s.pointLength||o.spotLength!==s.spotLength||o.rectAreaLength!==s.rectAreaLength||o.hemiLength!==s.hemiLength||o.shadowsLength!==s.shadowsLength)o.stateID=s.stateID,o.directionalLength=s.directionalLength,o.pointLength=s.pointLength,o.spotLength=s.spotLength,o.rectAreaLength=s.rectAreaLength,o.hemiLength=s.hemiLength,o.shadowsLength=s.shadowsLength,d=!1;else if(c.shaderID!==void 0)return;else d=!1;if(d){if(c.shaderID){var m=ke[c.shaderID];r.shader={name:e.type,uniforms:Se(m.uniforms),vertexShader:m.vertexShader,fragmentShader:m.fragmentShader}}else r.shader={name:e.type,uniforms:e.uniforms,vertexShader:e.vertexShader,fragmentShader:e.fragmentShader};e.onBeforeCompile(r.shader,p),l=J.getProgramCode(e,c),u=J.acquireProgram(e,r.shader,c,l),r.program=u,e.program=u}var h=u.getAttributes();if(e.morphTargets){e.numSupportedMorphTargets=0;for(var g=0;g<p.maxMorphTargets;g++)h[`morphTarget`+g]>=0&&e.numSupportedMorphTargets++}if(e.morphNormals){e.numSupportedMorphNormals=0;for(var g=0;g<p.maxMorphNormals;g++)h[`morphNormal`+g]>=0&&e.numSupportedMorphNormals++}var _=r.shader.uniforms;(!e.isShaderMaterial&&!e.isRawShaderMaterial||e.clipping===!0)&&(r.numClippingPlanes=L.numPlanes,r.numIntersection=L.numIntersection,_.clippingPlanes=L.uniform),r.fog=t,o===void 0&&(r.lightsHash=o={}),o.stateID=s.stateID,o.directionalLength=s.directionalLength,o.pointLength=s.pointLength,o.spotLength=s.spotLength,o.rectAreaLength=s.rectAreaLength,o.hemiLength=s.hemiLength,o.shadowsLength=s.shadowsLength,e.lights&&(_.ambientLightColor.value=i.state.ambient,_.directionalLights.value=i.state.directional,_.spotLights.value=i.state.spot,_.rectAreaLights.value=i.state.rectArea,_.pointLights.value=i.state.point,_.hemisphereLights.value=i.state.hemi,_.directionalShadowMap.value=i.state.directionalShadowMap,_.directionalShadowMatrix.value=i.state.directionalShadowMatrix,_.spotShadowMap.value=i.state.spotShadowMap,_.spotShadowMatrix.value=i.state.spotShadowMatrix,_.pointShadowMap.value=i.state.pointShadowMap,_.pointShadowMatrix.value=i.state.pointShadowMatrix);var v=r.program.getUniforms();r.uniformsList=It.seqWithValue(v.seq,_)}function Ge(e,t,n,r){k=0;var i=q.get(n),a=f.state.lights,o=i.lightsHash,s=a.state.hash;if(R&&(ee||e!==x)){var c=e===x&&n.id===y;L.setState(n.clippingPlanes,n.clipIntersection,n.clipShadows,e,i,c)}n.needsUpdate===!1&&(i.program===void 0||n.fog&&i.fog!==t||n.lights&&(o.stateID!==s.stateID||o.directionalLength!==s.directionalLength||o.pointLength!==s.pointLength||o.spotLength!==s.spotLength||o.rectAreaLength!==s.rectAreaLength||o.hemiLength!==s.hemiLength||o.shadowsLength!==s.shadowsLength)||i.numClippingPlanes!==void 0&&(i.numClippingPlanes!==L.numPlanes||i.numIntersection!==L.numIntersection))&&(n.needsUpdate=!0),n.needsUpdate&&=(He(n,t,r),!1);var l=!1,u=!1,h=!1,g=i.program,_=g.getUniforms(),v=i.shader.uniforms;if(W.useProgram(g.program)&&(l=!0,u=!0,h=!0),n.id!==y&&(y=n.id,u=!0),l||x!==e){if(_.setValue(B,`projectionMatrix`,e.projectionMatrix),U.logarithmicDepthBuffer&&_.setValue(B,`logDepthBufFC`,2/(Math.log(e.far+1)/Math.LN2)),x!==e&&(x=e,u=!0,h=!0),n.isShaderMaterial||n.isMeshPhongMaterial||n.isMeshStandardMaterial||n.envMap){var b=_.map.cameraPosition;b!==void 0&&b.setValue(B,z.setFromMatrixPosition(e.matrixWorld))}(n.isMeshPhongMaterial||n.isMeshLambertMaterial||n.isMeshBasicMaterial||n.isMeshStandardMaterial||n.isShaderMaterial||n.skinning)&&_.setValue(B,`viewMatrix`,e.matrixWorldInverse)}if(n.skinning){_.setOptional(B,r,`bindMatrix`),_.setOptional(B,r,`bindMatrixInverse`);var S=r.skeleton;if(S){var C=S.bones;if(U.floatVertexTextures){if(S.boneTexture===void 0){var T=Math.sqrt(C.length*4);T=w.ceilPowerOfTwo(T),T=Math.max(T,4);var E=new Float32Array(T*T*4);E.set(S.boneMatrices);var D=new Ee(E,T,T,m,d);D.needsUpdate=!0,S.boneMatrices=E,S.boneTexture=D,S.boneTextureSize=T}_.setValue(B,`boneTexture`,S.boneTexture),_.setValue(B,`boneTextureSize`,S.boneTextureSize)}else _.setOptional(B,S,`boneMatrices`)}}return u&&(_.setValue(B,`toneMappingExposure`,p.toneMappingExposure),_.setValue(B,`toneMappingWhitePoint`,p.toneMappingWhitePoint),n.lights&&at(v,h),t&&n.fog&&Ze(v,t),n.isMeshBasicMaterial?Ke(v,n):n.isMeshLambertMaterial?(Ke(v,n),Qe(v,n)):n.isMeshPhongMaterial?(Ke(v,n),n.isMeshToonMaterial?et(v,n):$e(v,n)):n.isMeshStandardMaterial?(Ke(v,n),n.isMeshPhysicalMaterial?nt(v,n):tt(v,n)):n.isMeshMatcapMaterial?(Ke(v,n),Q(v,n)):n.isMeshDepthMaterial?(Ke(v,n),$(v,n)):n.isMeshDistanceMaterial?(Ke(v,n),rt(v,n)):n.isMeshNormalMaterial?(Ke(v,n),it(v,n)):n.isLineBasicMaterial?(qe(v,n),n.isLineDashedMaterial&&Je(v,n)):n.isPointsMaterial?Ye(v,n):n.isSpriteMaterial?Xe(v,n):n.isShadowMaterial&&(v.color.value=n.color,v.opacity.value=n.opacity),v.ltc_1!==void 0&&(v.ltc_1.value=Z.LTC_1),v.ltc_2!==void 0&&(v.ltc_2.value=Z.LTC_2),It.upload(B,i.uniformsList,v,p)),n.isShaderMaterial&&n.uniformsNeedUpdate===!0&&(It.upload(B,i.uniformsList,v,p),n.uniformsNeedUpdate=!1),n.isSpriteMaterial&&_.setValue(B,`center`,r.center),_.setValue(B,`modelViewMatrix`,r.modelViewMatrix),_.setValue(B,`normalMatrix`,r.normalMatrix),_.setValue(B,`modelMatrix`,r.matrixWorld),g}function Ke(e,t){e.opacity.value=t.opacity,t.color&&(e.diffuse.value=t.color),t.emissive&&e.emissive.value.copy(t.emissive).multiplyScalar(t.emissiveIntensity),t.map&&(e.map.value=t.map),t.alphaMap&&(e.alphaMap.value=t.alphaMap),t.specularMap&&(e.specularMap.value=t.specularMap),t.envMap&&(e.envMap.value=t.envMap,e.flipEnvMap.value=t.envMap.isCubeTexture?-1:1,e.reflectivity.value=t.reflectivity,e.refractionRatio.value=t.refractionRatio,e.maxMipLevel.value=q.get(t.envMap).__maxMipLevel),t.lightMap&&(e.lightMap.value=t.lightMap,e.lightMapIntensity.value=t.lightMapIntensity),t.aoMap&&(e.aoMap.value=t.aoMap,e.aoMapIntensity.value=t.aoMapIntensity);var n;t.map?n=t.map:t.specularMap?n=t.specularMap:t.displacementMap?n=t.displacementMap:t.normalMap?n=t.normalMap:t.bumpMap?n=t.bumpMap:t.roughnessMap?n=t.roughnessMap:t.metalnessMap?n=t.metalnessMap:t.alphaMap?n=t.alphaMap:t.emissiveMap&&(n=t.emissiveMap),n!==void 0&&(n.isWebGLRenderTarget&&(n=n.texture),n.matrixAutoUpdate===!0&&n.updateMatrix(),e.uvTransform.value.copy(n.matrix))}function qe(e,t){e.diffuse.value=t.color,e.opacity.value=t.opacity}function Je(e,t){e.dashSize.value=t.dashSize,e.totalSize.value=t.dashSize+t.gapSize,e.scale.value=t.scale}function Ye(e,t){e.diffuse.value=t.color,e.opacity.value=t.opacity,e.size.value=t.size*M,e.scale.value=j*.5,e.map.value=t.map,t.map!==null&&(t.map.matrixAutoUpdate===!0&&t.map.updateMatrix(),e.uvTransform.value.copy(t.map.matrix))}function Xe(e,t){e.diffuse.value=t.color,e.opacity.value=t.opacity,e.rotation.value=t.rotation,e.map.value=t.map,t.map!==null&&(t.map.matrixAutoUpdate===!0&&t.map.updateMatrix(),e.uvTransform.value.copy(t.map.matrix))}function Ze(e,t){e.fogColor.value=t.color,t.isFog?(e.fogNear.value=t.near,e.fogFar.value=t.far):t.isFogExp2&&(e.fogDensity.value=t.density)}function Qe(e,t){t.emissiveMap&&(e.emissiveMap.value=t.emissiveMap)}function $e(e,t){e.specular.value=t.specular,e.shininess.value=Math.max(t.shininess,1e-4),t.emissiveMap&&(e.emissiveMap.value=t.emissiveMap),t.bumpMap&&(e.bumpMap.value=t.bumpMap,e.bumpScale.value=t.bumpScale,t.side===1&&(e.bumpScale.value*=-1)),t.normalMap&&(e.normalMap.value=t.normalMap,e.normalScale.value.copy(t.normalScale),t.side===1&&e.normalScale.value.negate()),t.displacementMap&&(e.displacementMap.value=t.displacementMap,e.displacementScale.value=t.displacementScale,e.displacementBias.value=t.displacementBias)}function et(e,t){$e(e,t),t.gradientMap&&(e.gradientMap.value=t.gradientMap)}function tt(e,t){e.roughness.value=t.roughness,e.metalness.value=t.metalness,t.roughnessMap&&(e.roughnessMap.value=t.roughnessMap),t.metalnessMap&&(e.metalnessMap.value=t.metalnessMap),t.emissiveMap&&(e.emissiveMap.value=t.emissiveMap),t.bumpMap&&(e.bumpMap.value=t.bumpMap,e.bumpScale.value=t.bumpScale,t.side===1&&(e.bumpScale.value*=-1)),t.normalMap&&(e.normalMap.value=t.normalMap,e.normalScale.value.copy(t.normalScale),t.side===1&&e.normalScale.value.negate()),t.displacementMap&&(e.displacementMap.value=t.displacementMap,e.displacementScale.value=t.displacementScale,e.displacementBias.value=t.displacementBias),t.envMap&&(e.envMapIntensity.value=t.envMapIntensity)}function nt(e,t){tt(e,t),e.reflectivity.value=t.reflectivity,e.clearCoat.value=t.clearCoat,e.clearCoatRoughness.value=t.clearCoatRoughness}function Q(e,t){t.matcap&&(e.matcap.value=t.matcap),t.bumpMap&&(e.bumpMap.value=t.bumpMap,e.bumpScale.value=t.bumpScale,t.side===1&&(e.bumpScale.value*=-1)),t.normalMap&&(e.normalMap.value=t.normalMap,e.normalScale.value.copy(t.normalScale),t.side===1&&e.normalScale.value.negate()),t.displacementMap&&(e.displacementMap.value=t.displacementMap,e.displacementScale.value=t.displacementScale,e.displacementBias.value=t.displacementBias)}function $(e,t){t.displacementMap&&(e.displacementMap.value=t.displacementMap,e.displacementScale.value=t.displacementScale,e.displacementBias.value=t.displacementBias)}function rt(e,t){t.displacementMap&&(e.displacementMap.value=t.displacementMap,e.displacementScale.value=t.displacementScale,e.displacementBias.value=t.displacementBias),e.referencePosition.value.copy(t.referencePosition),e.nearDistance.value=t.nearDistance,e.farDistance.value=t.farDistance}function it(e,t){t.bumpMap&&(e.bumpMap.value=t.bumpMap,e.bumpScale.value=t.bumpScale,t.side===1&&(e.bumpScale.value*=-1)),t.normalMap&&(e.normalMap.value=t.normalMap,e.normalScale.value.copy(t.normalScale),t.side===1&&e.normalScale.value.negate()),t.displacementMap&&(e.displacementMap.value=t.displacementMap,e.displacementScale.value=t.displacementScale,e.displacementBias.value=t.displacementBias)}function at(e,t){e.ambientLightColor.needsUpdate=t,e.directionalLights.needsUpdate=t,e.pointLights.needsUpdate=t,e.spotLights.needsUpdate=t,e.rectAreaLights.needsUpdate=t,e.hemisphereLights.needsUpdate=t}function ot(){var e=k;return e>=U.maxTextures&&console.warn(`THREE.WebGLRenderer: Trying to use `+e+` texture units while this GPU supports only `+U.maxTextures),k+=1,e}this.allocTextureUnit=ot,this.setTexture2D=function(){var e=!1;return function(t,n){t&&t.isWebGLRenderTarget&&(e||=(console.warn(`THREE.WebGLRenderer.setTexture2D: don't use render targets as textures. Use their .texture property instead.`),!0),t=t.texture),re.setTexture2D(t,n)}}(),this.setTexture3D=function(){return function(e,t){re.setTexture3D(e,t)}}(),this.setTexture=function(){var e=!1;return function(t,n){e||=(console.warn(`THREE.WebGLRenderer: .setTexture is deprecated, use setTexture2D instead.`),!0),re.setTexture2D(t,n)}}(),this.setTextureCube=function(){var e=!1;return function(t,n){t&&t.isWebGLRenderTargetCube&&(e||=(console.warn(`THREE.WebGLRenderer.setTextureCube: don't use cube render targets as textures. Use their .texture property instead.`),!0),t=t.texture),t&&t.isCubeTexture||Array.isArray(t.image)&&t.image.length===6?re.setTextureCube(t,n):re.setTextureCubeDynamic(t,n)}}(),this.setFramebuffer=function(e){g=e},this.getRenderTarget=function(){return _},this.setRenderTarget=function(e){_=e,e&&q.get(e).__webglFramebuffer===void 0&&re.setupRenderTarget(e);var t=g,n=!1;if(e){var r=q.get(e).__webglFramebuffer;e.isWebGLRenderTargetCube?(t=r[e.activeCubeFace],n=!0):t=e.isWebGLMultisampleRenderTarget?q.get(e).__webglMultisampledFramebuffer:r,C.copy(e.viewport),T.copy(e.scissor),D=e.scissorTest}else C.copy(N).multiplyScalar(M),T.copy(P).multiplyScalar(M),D=F;if(v!==t&&(B.bindFramebuffer(B.FRAMEBUFFER,t),v=t),W.viewport(C),W.scissor(T),W.setScissorTest(D),n){var i=q.get(e.texture);B.framebufferTexture2D(B.FRAMEBUFFER,B.COLOR_ATTACHMENT0,B.TEXTURE_CUBE_MAP_POSITIVE_X+e.activeCubeFace,i.__webglTexture,e.activeMipMapLevel)}},this.readRenderTargetPixels=function(e,t,n,r,i,a){if(!(e&&e.isWebGLRenderTarget)){console.error(`THREE.WebGLRenderer.readRenderTargetPixels: renderTarget is not THREE.WebGLRenderTarget.`);return}var o=q.get(e).__webglFramebuffer;if(o){var s=!1;o!==v&&(B.bindFramebuffer(B.FRAMEBUFFER,o),s=!0);try{var c=e.texture,l=c.format,u=c.type;if(l!==1023&&fe.convert(l)!==B.getParameter(B.IMPLEMENTATION_COLOR_READ_FORMAT)){console.error(`THREE.WebGLRenderer.readRenderTargetPixels: renderTarget is not in RGBA or implementation defined format.`);return}if(u!==1009&&fe.convert(u)!==B.getParameter(B.IMPLEMENTATION_COLOR_READ_TYPE)&&!(u===1015&&(U.isWebGL2||H.get(`OES_texture_float`)||H.get(`WEBGL_color_buffer_float`)))&&!(u===1016&&(U.isWebGL2?H.get(`EXT_color_buffer_float`):H.get(`EXT_color_buffer_half_float`)))){console.error(`THREE.WebGLRenderer.readRenderTargetPixels: renderTarget is not in UnsignedByteType or implementation defined type.`);return}B.checkFramebufferStatus(B.FRAMEBUFFER)===B.FRAMEBUFFER_COMPLETE?t>=0&&t<=e.width-r&&n>=0&&n<=e.height-i&&B.readPixels(t,n,r,i,fe.convert(l),fe.convert(u),a):console.error(`THREE.WebGLRenderer.readRenderTargetPixels: readPixels from renderTarget failed. Framebuffer not complete.`)}finally{s&&B.bindFramebuffer(B.FRAMEBUFFER,v)}}},this.copyFramebufferToTexture=function(e,t,n){var r=t.image.width,i=t.image.height,a=fe.convert(t.format);this.setTexture2D(t,0),B.copyTexImage2D(B.TEXTURE_2D,n||0,a,e.x,e.y,r,i,0)},this.copyTextureToTexture=function(e,t,n,r){var i=t.image.width,a=t.image.height,o=fe.convert(n.format),s=fe.convert(n.type);this.setTexture2D(n,0),t.isDataTexture?B.texSubImage2D(B.TEXTURE_2D,r||0,e.x,e.y,i,a,o,s,t.image.data):B.texSubImage2D(B.TEXTURE_2D,r||0,e.x,e.y,o,s,t.image)}}var En=`
varying vec2 vUv;

void main() {
    vUv = vec2(uv.x, 1.0 - uv.y);
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}
`,Dn=`
varying vec2 vUv;
uniform sampler2D tDiffuse;

void main() {
    gl_FragColor = texture2D(tDiffuse, vUv);
}
`,On=class{renderer;material;sceneRTT;cameraRTT;rtTexture;canvas=null;animated=!1;zoom=1;orientation=`portrait`;selfie=!1;constructor(){let e=new P;e.needsUpdate=!0,this.material=new we({uniforms:{tDiffuse:{value:e}},vertexShader:En,fragmentShader:Dn}),this.cameraRTT=this.buildCamera(!0),this.sceneRTT=this.buildScene(),this.rtTexture=this.buildTarget(),this.renderer=new Tn,this.renderer.setSize(window.innerWidth,window.innerHeight),this.renderer.autoClear=!1;let t=document.createElement(`div`);t.id=`three-game-render`,t.style.display=`none`,t.appendChild(this.renderer.domElement),document.body.append(t),window.addEventListener(`resize`,()=>this.rebuild(!this.animated)),requestAnimationFrame(this.animate)}renderToTarget(e){this.rebuild(!1),this.canvas=e,this.animated=!0}setZoom(e){this.zoom=e>0?e:1,this.animated&&this.rebuild(!1)}setOrientation(e){this.orientation=e,this.animated&&this.rebuild(!1)}setSelfie(e){this.selfie=e,this.animated&&this.rebuild(!1)}stop(){this.animated=!1,this.canvas=null,this.rebuild(!0)}buildCamera(n){let r=window.innerWidth,i=window.innerHeight,a=new ge(r/-2,r/2,i/2,i/-2,-1e4,1e4);if(a.position.z=0,n)a.setViewOffset(r,i,0,0,r,i);else{let n=this.selfie?t:0,o=e(r,i,this.zoom,this.orientation,n);a.setViewOffset(r,i,o.offsetX,o.offsetY,o.width,o.height)}return a}buildScene(){let e=new xe,t=new me(new be(window.innerWidth,window.innerHeight),this.material);return t.position.z=-100,e.add(t),e}buildTarget(){return new Te(window.innerWidth,window.innerHeight,{minFilter:s,magFilter:o,format:m,type:l})}rebuild(e){this.cameraRTT=this.buildCamera(e),this.sceneRTT=this.buildScene(),this.rtTexture=this.buildTarget(),this.renderer.setSize(window.innerWidth,window.innerHeight)}animate=()=>{if(requestAnimationFrame(this.animate),!this.animated||!this.canvas)return;let e=window.innerWidth,t=window.innerHeight;this.renderer.clear(),this.renderer.render(this.sceneRTT,this.cameraRTT,this.rtTexture,!0);let n=new Uint8Array(e*t*4);this.renderer.readRenderTargetPixels(this.rtTexture,0,0,e,t,n),this.canvas.width=e,this.canvas.height=t;let r=this.canvas.getContext(`2d`);r&&r.putImageData(new ImageData(new Uint8ClampedArray(n.buffer),e,t),0,0)}};export{On as GameRender};