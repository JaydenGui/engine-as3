﻿package org.ijelly
{
	import flash.utils.getTimer;

	public class TilePath
	{
		private const COST_HORIZONTAL:int = 9;  
        private const COST_VERTICAL:int   = 8;  
        private const COST_DIAGONAL:int   = 8;  
        private const evenDir:Array   = [[-1,-1],[0,-2],[0,-1],[1,0],[0,1],[0,2],[-1,1],[-1,0]];//八个方向数组，从节点正上方开始，顺时针排列(当前点Y值为偶数)
		private const oddDir:Array    = [[0,-1],[0,-2],[1,-1],[1,0],[1,1],[0,2],[0,1],[-1,0]];//Y值为奇数
	     
		private var aOpenList:Array; 
		private var aCloseList:Object; 
		private var ndCurrent:ANode;
		//地图数据
		private var mapData:Array; 
		private var ndStart:ANode;
		private var ndEnd:ANode;
		private var mapwidth:int;
		private var mapheight:int;
		
	    //返回路径数组
		public var aPath:Array;
		
		private var indexArr:Object;

		public function TilePath() 
		{
			
		}
		public function initData(amap:Array):void
		{
			mapwidth = amap[0].length-1;
			mapheight = amap.length-1;
			mapData = amap;
			
			ndStart = new ANode(0,0);
			ndEnd = new ANode(0,0);
		}
		/**
		 * 
		 * 取得指定点周围可通过的点，从正上方开始
		 * */
		private function GetRound(x:int,y:int):Array
		{
			var arr:Array = [];
			var xp:int,yp:int;
			var aDir:Array =(ndCurrent.y&1)==0?evenDir:oddDir;
			var l:int = 8;//adir.length==8
			for(var i:int = 0;i<l;i++)
			{
				var _arr:Array = aDir[i];
				xp = x + _arr[0];
				yp = y + _arr[1];
				if( IsPass(xp,yp)&&
				    !IsCorner(xp,yp)&&
				    !IsInClose(xp,yp))
				arr[arr.length] = [xp,yp];				
			}			
			return arr;
		}	
		/**
		 *  是否已经在关闭列表中 
		 * @return 
		 * 
		 */		
		private function IsInClose(xp:int,yp:int):Boolean
		{
			if(aCloseList.hasOwnProperty(xp+','+yp))
			   return true;
			return false;   
		}		
		/**
		 * 
		 * 是否可以通过
		 * */		
		private function IsPass(x:int,y:int):Boolean
		{ 
			  if(x<0 ||    //是否超出地图范围
			   x>mapwidth || 
			   y < 0 || 
			   y>mapheight)
				return false;  
			return mapData[y][x]==1?false:true;
		}				
		/**
		 * 
		 * 是否是拐角
		 *   @return :true 代表是拐点
		 * */
		private function IsCorner(x:int,y:int):Boolean
		{
			   var temp:int;
			   //此为水平方向
				if(y==ndCurrent.y)
				{
					if((y&1)==0)
					{
						if(x > ndCurrent.x)
						{
							if(!IsPass(ndCurrent.x,ndCurrent.y+1)||!IsPass(ndCurrent.x,ndCurrent.y-1))
							  return true;					 
						}
						else if(x < ndCurrent.x)
						{
							if(!IsPass(x,y+1)||!IsPass(x,y-1))
							 return true;	
						}
					}
					else 
					{
						if(x > ndCurrent.x)
						{
							if(!IsPass(x,y+1)||!IsPass(x,y-1))
							 return true;				 
						}
						else if(x < ndCurrent.x)
						{
							if(!IsPass(ndCurrent.x,ndCurrent.y-1)||!IsPass(ndCurrent.x,ndCurrent.y+1))
							 return true;
						}
					}
				}
				//此为竖直方向
				else if((temp=ndCurrent.y-y)==2||temp==-2)
				{
					if((y&1)==1)//奇数
					{
	                   if(y<ndCurrent.y)
	                    {
	                    	if(!IsPass(x,y+1)||!IsPass(x+1,y+1))
							 return true;
	                    }
	                    else if(y>ndCurrent.y)
	                    {
	                    	if(!IsPass(x,y-1)||!IsPass(x+1,y-1))
							 return true;
	                    }
	    			}
	    			else
	    			{
	    				if(y<ndCurrent.y)
	                    {
	                    	if(!IsPass(x-1,y+1)||!IsPass(x,y+1))
							 return true;
	                    }
	                    else if(y>ndCurrent.y)
	                    {
	                    	if(!IsPass(x-1,y-1)||!IsPass(x,y-1))
							return true;
	                    }
	    			}
				}
			return false;
		}

		/**
		 * 二叉堆，增加元素 
		 * @param target 增加的对象
		 * @param two    二叉堆数组
		 * 
		 */		
		private function add(target:ANode,two:Array):void
		{
			var index:int = two.length;
			var temp:ANode;
			var parent:int;
			two[index] = target;
					
			parent = index*.5;
			while(parent>0)
			{	
				if(two[parent].F>two[index].F)
				{
				     temp = two[parent];
					 two[parent] = two[index];
					 two[index] = temp;
					 index = parent;	
				}
				else
				   break;
				   
				parent = index*.5;   
			  }
			  indexArr[target.x+','+target.y] = target;
			}
			/**
			 * 二叉堆中取出根对象 
			 * @param two  二叉堆数组
			 * @return    跟对象
			 * 
			 */			
			private function remove(two:Array):ANode
			{
				var obj:ANode;
			 	if(two.length==1)
				{
			 	    obj = two.pop();
			 	} 
			 	else
			 	{
					var index:int=0;
					obj = two[index];
					two[index] = two.pop();
					//左子树和右子树
					var child1:int = (index+1)*2-1; 
					var child2:int;
					var child:int;
					var temp:ANode;
					while(two[child1])
					{	
						child2 = child1+1;
						child = child1;
						if(two[child2])
						{
							if(two[child1].F>two[child2].F)
								child = child2;   
						}
							
						if(two[child].F<two[index].F)
						{
							temp = two[child];
							two[child] = two[index];
							two[index] = temp;
							index = child;	
							child1 = (index+1)*2-1; 
						}
						else 
						   break;
					}
				}
				delete indexArr[obj.x+','+obj.y];
				return obj;
			}
			/**
			 *修改二叉堆元素 
			 * @param index 该对象所在数组的索引
			 * @param target 需要修改的对象
			 * @param two   二叉堆数组
			 * 
			 */			
			private function edit(index:int,target:ANode,two:Array):void
			{
				var temp:ANode;
				var parent:int;
							
				parent = index*.5;
				while(parent>0)
				{						
					if(two[parent].F>two[index].F)
					{
						temp = two[parent];
						two[parent] = two[index];
						two[index] = temp;
						index = parent;	
					}
					else
						break;
						
					parent = index*.5;
				}
			}
		/**
		 * 
		 * 取得F值，参数为某一节点周围的节点
		 * */
		private function GetF(around:Array):void
		{ 
			var F:int,H:int,G:int;
			var index:int;
			var node:ANode;
			var l:int = around.length;
			for(var i:int = 0;i<l;i++)
			{		
				var apos:Array = around[i];							
				G = getG(ndCurrent,apos);
				node = indexArr[apos[0]+','+apos[1]];
				if(node)  //如果当前点已存在aOpenlist数组中
				{
					  if(G<node.G) //如果当前点G值更小，更改父节点
					{ 
					 	index = aOpenList.indexOf(node);
						node.F = G + node.H;
						node.G = G;
						node.parent = ndCurrent;
						edit(index,node,aOpenList);
				 	}	 			
				}
				else
				{
					H = getH(ndEnd,apos);
					F= G + H;
					var newnode:ANode = new ANode(apos[0],apos[1]);
					newnode.F = F;
					newnode.G = G;
					newnode.H = H;
					newnode.parent = ndCurrent;
					add(newnode,aOpenList);
				}			
			}
		}
		private function getG(currentArr:ANode,arr:Array):int
		{
		    var g:int;   
            if (currentArr.y == arr[1])            // 横向  左右  
            {  
                g = currentArr.G + this.COST_HORIZONTAL;  
            }  
            else if (currentArr.y+2 == arr[1] || currentArr.y-2 == arr[1])// 竖向  上下  
            {  
                g = currentArr.G + this.COST_VERTICAL*2;  
            }  
            else                        // 斜向  左上 左下 右上 右下  
            {  
                g = currentArr.G + this.COST_DIAGONAL;  
            }  
            return g;  	
		}
		/**  
         * 计算H值  
         * H值估计值为终止节点的水平距离-当前结点的水平距离+竖直距离
         */  
        private function getH(endNode:ANode, node:Array):int  
        {  
            var dx:int,dy:int;
            var current_x:int = node[0]  + (node[1]&1)*.5;  
            var end_x:int    = endNode.x  + (endNode.y&1)*.5;   
            dx = (end_x - current_x)*COST_VERTICAL;  
            dx = dx<0?dx*-1:dx;   
            dy = (endNode.y - node[1])*COST_HORIZONTAL;  
            dy = dy<0?dy*-1:dy;
            return dx + dy;  
        }  
		/**
		 * 
		 * 搜索路径
		 * */
		public function DoSearch(starx:int,stary:int,targetx:int,targety:int):Boolean
		{
		    destroyData();
		    ndStart.x = starx,ndStart.y = stary;
			ndEnd.x   = targetx,ndEnd.y = targety;	
			aOpenList.push(ndStart);			
			  while(aOpenList.length>0)
			{
				//将开启列表最后一位元素列入关闭列表
				ndCurrent = remove(aOpenList);
				aCloseList[ndCurrent.x+','+ndCurrent.y] = ndCurrent;	
				GetF(GetRound(ndCurrent.x,ndCurrent.y)); 	

                //如果当前节点是目标节点，路径找到，跳出循环返回true	
				if(ndCurrent.x == ndEnd.x&&
				   ndCurrent.y == ndEnd.y) 
				{				
					GetPath(ndCurrent);	
				    optimizePath(aPath);
					return true;
				}
				
			}		
			return false;
		}
		//清空各数组
		private function destroyData():void
		{
			aOpenList = [];
			aCloseList = {};
			aPath = [];		
			indexArr = {};
		}
		//取得路径数组
		private function GetPath(node:ANode):void
		{
            if(node)
            {
               aPath[aPath.length] = [node.x,node.y];
               GetPath(node.parent);
            }

		}	
		/**
         * 优化路径
         *     只取转折点
         *   @arr:路径数组
         *   @return 优化后的数组
         * */
          private function optimizePath(arr:Array):void
         {
         	 var l:int = arr.length-1;
         	 if(arr.length>1)  //优化路径，去掉初始点
			 {
				l = arr.length-1;
				var fx:int = arr[l][0]-ndStart.x;
				var fy:int = arr[l][1]-ndStart.y;
				fx=fx>0?fx:-fx;
				fy = fy>0?fy:-fy;
				if(fx<=1||fy<=1) arr.pop();
			 } 
         } 
	}
}
   final  class ANode
	{
		public var x:int;
		public var y:int;
		public var G:int;
		public var H:int;
		public var F:int;
		public var parent:ANode;

		public function ANode(_x:int,_y:int)
		{
			this.x = _x;
			this.y = _y;
		}
		
	}