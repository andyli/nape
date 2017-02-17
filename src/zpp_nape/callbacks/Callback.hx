package zpp_nape.callbacks;
import zpp_nape.Const;
import zpp_nape.util.Array2;
import zpp_nape.ID;
import zpp_nape.util.Circular;
import zpp_nape.util.DisjointSetForest;
import zpp_nape.util.Debug;
import zpp_nape.util.FastHash;
import zpp_nape.util.Flags;
import zpp_nape.util.Math;
import zpp_nape.util.Names;
import zpp_nape.util.Pool;
import zpp_nape.util.Queue;
import zpp_nape.util.RBTree;
import zpp_nape.util.UserData;
import zpp_nape.util.WrapLists;
import zpp_nape.util.Lists;
import zpp_nape.space.Broadphase;
import zpp_nape.space.DynAABBPhase;
import zpp_nape.space.SweepPhase;
import zpp_nape.shape.Circle;
import zpp_nape.shape.Edge;
import zpp_nape.shape.Polygon;
import zpp_nape.space.Space;
import zpp_nape.shape.Shape;
import zpp_nape.phys.Compound;
import zpp_nape.phys.FeatureMix;
import zpp_nape.phys.FluidProperties;
import zpp_nape.phys.Body;
import zpp_nape.phys.Interactor;
import zpp_nape.phys.Material;
import zpp_nape.geom.AABB;
import zpp_nape.geom.Convex;
import zpp_nape.geom.ConvexRayResult;
import zpp_nape.geom.Cutter;
import zpp_nape.geom.Geom;
import zpp_nape.geom.GeomPoly;
import zpp_nape.geom.MarchingSquares;
import zpp_nape.geom.Collide;
import zpp_nape.geom.Mat23;
import zpp_nape.geom.MatMN;
import zpp_nape.geom.Monotone;
import zpp_nape.geom.PartitionedPoly;
import zpp_nape.geom.MatMath;
import zpp_nape.geom.PolyIter;
import zpp_nape.geom.Ray;
import zpp_nape.geom.Simple;
import zpp_nape.geom.Simplify;
import zpp_nape.geom.Triangular;
import zpp_nape.geom.Vec2;
import zpp_nape.geom.Vec3;
import zpp_nape.geom.SweepDistance;
import zpp_nape.geom.VecMath;
import zpp_nape.dynamics.Contact;
import zpp_nape.dynamics.InteractionFilter;
import zpp_nape.dynamics.InteractionGroup;
import zpp_nape.dynamics.SpaceArbiterList;
import zpp_nape.dynamics.Arbiter;
import zpp_nape.constraint.AngleJoint;
import zpp_nape.constraint.DistanceJoint;
import zpp_nape.constraint.Constraint;
import zpp_nape.constraint.LinearJoint;
import zpp_nape.constraint.MotorJoint;
import zpp_nape.constraint.LineJoint;
import zpp_nape.constraint.PivotJoint;
import zpp_nape.constraint.UserConstraint;
import zpp_nape.constraint.WeldJoint;
import zpp_nape.constraint.PulleyJoint;
import zpp_nape.callbacks.CbSetPair;
import zpp_nape.callbacks.CbType;
import zpp_nape.callbacks.CbSet;
import zpp_nape.callbacks.OptionType;
import nape.Config;
import nape.TArray;
import zpp_nape.callbacks.Listener;
import nape.util.BitmapDebug;
import nape.util.Debug;
import nape.space.Broadphase;
import nape.util.ShapeDebug;
import nape.shape.Circle;
import nape.shape.Edge;
import nape.shape.EdgeIterator;
import nape.shape.EdgeList;
import nape.space.Space;
import nape.shape.Polygon;
import nape.shape.ShapeIterator;
import nape.shape.ShapeList;
import nape.shape.ShapeType;
import nape.shape.Shape;
import nape.shape.ValidationResult;
import nape.phys.BodyIterator;
import nape.phys.BodyList;
import nape.phys.BodyType;
import nape.phys.Compound;
import nape.phys.CompoundIterator;
import nape.phys.CompoundList;
import nape.phys.FluidProperties;
import nape.phys.GravMassMode;
import nape.phys.InertiaMode;
import nape.phys.Interactor;
import nape.phys.InteractorIterator;
import nape.phys.InteractorList;
import nape.phys.MassMode;
import nape.phys.Material;
import nape.phys.Body;
import nape.geom.ConvexResult;
import nape.geom.ConvexResultIterator;
import nape.geom.ConvexResultList;
import nape.geom.Geom;
import nape.geom.AABB;
import nape.geom.GeomPoly;
import nape.geom.GeomPolyList;
import nape.geom.GeomVertexIterator;
import nape.geom.IsoFunction;
import nape.geom.GeomPolyIterator;
import nape.geom.MarchingSquares;
import nape.geom.Mat23;
import nape.geom.MatMN;
import nape.geom.RayResult;
import nape.geom.RayResultIterator;
import nape.geom.RayResultList;
import nape.geom.Ray;
import nape.geom.Vec2Iterator;
import nape.geom.Vec2List;
import nape.geom.Vec3;
import nape.geom.Winding;
import nape.dynamics.Arbiter;
import nape.geom.Vec2;
import nape.dynamics.ArbiterIterator;
import nape.dynamics.ArbiterType;
import nape.dynamics.ArbiterList;
import nape.dynamics.CollisionArbiter;
import nape.dynamics.Contact;
import nape.dynamics.ContactIterator;
import nape.dynamics.ContactList;
import nape.dynamics.InteractionFilter;
import nape.dynamics.InteractionGroup;
import nape.dynamics.InteractionGroupIterator;
import nape.dynamics.InteractionGroupList;
import nape.dynamics.FluidArbiter;
import nape.constraint.AngleJoint;
import nape.constraint.ConstraintIterator;
import nape.constraint.ConstraintList;
import nape.constraint.Constraint;
import nape.constraint.DistanceJoint;
import nape.constraint.LinearJoint;
import nape.constraint.LineJoint;
import nape.constraint.PivotJoint;
import nape.constraint.PulleyJoint;
import nape.constraint.MotorJoint;
import nape.constraint.WeldJoint;
import nape.callbacks.BodyCallback;
import nape.callbacks.BodyListener;
import nape.callbacks.Callback;
import nape.constraint.UserConstraint;
import nape.callbacks.CbEvent;
import nape.callbacks.CbTypeIterator;
import nape.callbacks.CbTypeList;
import nape.callbacks.ConstraintCallback;
import nape.callbacks.CbType;
import nape.callbacks.InteractionCallback;
import nape.callbacks.ConstraintListener;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionType;
import nape.callbacks.Listener;
import nape.callbacks.ListenerList;
import nape.callbacks.ListenerType;
import nape.callbacks.OptionType;
import nape.callbacks.PreCallback;
import nape.callbacks.PreFlag;
import nape.callbacks.PreListener;
import nape.callbacks.ListenerIterator;
#if nape_swc@:keep #end
class ZPP_Callback{
    public var outer_body:Null<BodyCallback>=null;
    public var outer_con:Null<ConstraintCallback>=null;
    public var outer_int:Null<InteractionCallback>=null;
    #if(!NAPE_RELEASE_BUILD)
    public static var internal=false;
    #end
    public function wrapper_body(){
        if(outer_body==null){
            #if(!NAPE_RELEASE_BUILD)
            internal=true;
            #end
            outer_body=new BodyCallback();
            #if(!NAPE_RELEASE_BUILD)
            internal=false;
            #end
            outer_body.zpp_inner=this;
        }
        return outer_body;
    }
    public function wrapper_con(){
        if(outer_con==null){
            #if(!NAPE_RELEASE_BUILD)
            internal=true;
            #end
            outer_con=new ConstraintCallback();
            #if(!NAPE_RELEASE_BUILD)
            internal=false;
            #end
            outer_con.zpp_inner=this;
        }
        return outer_con;
    }
    public function wrapper_int(){
        if(outer_int==null){
            #if(!NAPE_RELEASE_BUILD)
            internal=true;
            #end
            outer_int=new InteractionCallback();
            #if(!NAPE_RELEASE_BUILD)
            internal=false;
            #end
            outer_int.zpp_inner=this;
        }
        genarbs();
        return outer_int;
    }
    public var event:Int=0;
    public var listener:ZPP_Listener=null;
    public var space:ZPP_Space=null;
    public var index:Int=0;
    public var next:ZPP_Callback=null;
    public var prev:ZPP_Callback=null;
    public var length:Int=0;
    public function push(obj:ZPP_Callback){
        {
            #if(NAPE_ASSERT&&!NAPE_RELEASE_BUILD)
            var res={
                obj!=null;
            };
            if(!res)throw "assert("+"obj!=null"+") :: "+("push null?");
            #end
        };
        if(prev!=null)prev.next=obj;
        else next=obj;
        obj.prev=prev;
        obj.next=null;
        prev=obj;
        length++;
    }
    public function push_rev(obj:ZPP_Callback){
        {
            #if(NAPE_ASSERT&&!NAPE_RELEASE_BUILD)
            var res={
                obj!=null;
            };
            if(!res)throw "assert("+"obj!=null"+") :: "+("push_rev null?");
            #end
        };
        if(next!=null)next.prev=obj;
        else prev=obj;
        obj.next=next;
        obj.prev=null;
        next=obj;
        length++;
    }
    public function pop():ZPP_Callback{
        {
            #if(NAPE_ASSERT&&!NAPE_RELEASE_BUILD)
            var res={
                next!=null;
            };
            if(!res)throw "assert("+"next!=null"+") :: "+("empty queue");
            #end
        };
        var ret=next;
        next=ret.next;
        if(next==null)prev=null;
        else next.prev=null;
        length--;
        return ret;
    }
    public function pop_rev():ZPP_Callback{
        {
            #if(NAPE_ASSERT&&!NAPE_RELEASE_BUILD)
            var res={
                prev!=null;
            };
            if(!res)throw "assert("+"prev!=null"+") :: "+("empty queue");
            #end
        };
        var ret=prev;
        prev=ret.prev;
        if(prev==null)next=null;
        else prev.next=null;
        length--;
        return ret;
    }
    public function empty(){
        return next==null;
    }
    public function clear(){
        while(!empty())pop();
    }
    public function splice(o:ZPP_Callback){
        var ret=o.next;
        if(o.prev==null){
            next=o.next;
            if(next!=null)next.prev=null;
            else prev=null;
        }
        else{
            o.prev.next=o.next;
            if(o.next!=null)o.next.prev=o.prev;
            else prev=o.prev;
        }
        length--;
        return ret;
    }
    public function rotateL(){
        push(pop());
    }
    public function rotateR(){
        push_rev(pop_rev());
    }
    public function cycleNext(o:ZPP_Callback){
        {
            #if(NAPE_ASSERT&&!NAPE_RELEASE_BUILD)
            var res={
                o!=null;
            };
            if(!res)throw "assert("+"o!=null"+") :: "+("cyclNext null?");
            #end
        };
        if(o.next==null)return next;
        else return o.next;
    }
    public function cyclePrev(o:ZPP_Callback){
        {
            #if(NAPE_ASSERT&&!NAPE_RELEASE_BUILD)
            var res={
                o!=null;
            };
            if(!res)throw "assert("+"o!=null"+") :: "+("cyclPrev null?");
            #end
        };
        if(o.prev==null)return prev;
        else return o.prev;
    }
    public function at(i:Int){
        {
            #if(NAPE_ASSERT&&!NAPE_RELEASE_BUILD)
            var res={
                i>=0&&i<length;
            };
            if(!res)throw "assert("+"i>=0&&i<length"+") :: "+("at index bounds");
            #end
        };
        var ret=next;
        while(i--!=0)ret=ret.next;
        return ret;
    }
    public function rev_at(i:Int){
        {
            #if(NAPE_ASSERT&&!NAPE_RELEASE_BUILD)
            var res={
                i>=0&&i<length;
            };
            if(!res)throw "assert("+"i>=0&&i<length"+") :: "+("rev_at index bounds");
            #end
        };
        var ret=prev;
        while(i--!=0)ret=ret.prev;
        return ret;
    }
    static public var zpp_pool:ZPP_Callback=null;
    #if NAPE_POOL_STATS 
    /**
     * @private
     */
    static public var POOL_CNT:Int=0;
    /**
     * @private
     */
    static public var POOL_TOT:Int=0;
    /**
     * @private
     */
    static public var POOL_ADD:Int=0;
    /**
     * @private
     */
    static public var POOL_ADDNEW:Int=0;
    /**
     * @private
     */
    static public var POOL_SUB:Int=0;
    #end
    
    #if NAPE_NO_INLINE#elseif(flash9&&flib)@:ns("flibdel")#end
    public#if NAPE_NO_INLINE#else inline #end
    function free():Void{
        int1=int2=null;
        body=null;
        constraint=null;
        listener=null;
        if(wrap_arbiters!=null){
            wrap_arbiters.zpp_inner.inner=null;
        }
        set=null;
    }
    #if NAPE_NO_INLINE#elseif(flash9&&flib)@:ns("flibdel")#end
    public#if NAPE_NO_INLINE#else inline #end
    function alloc():Void{}
    public var int1:ZPP_Interactor=null;
    public var int2:ZPP_Interactor=null;
    public var set:ZPP_CallbackSet=null;
    public var wrap_arbiters:ArbiterList=null;
    public var pre_arbiter:ZPP_Arbiter=null;
    public var pre_swapped:Bool=false;
    #if NAPE_NO_INLINE#elseif(flash9&&flib)@:ns("flibdel")#end
    public#if NAPE_NO_INLINE#else inline #end
    function genarbs(){
        {
            #if(NAPE_ASSERT&&!NAPE_RELEASE_BUILD)
            var res={
                set!=null;
            };
            if(!res)throw "assert("+"set!=null"+") :: "+("after ongoing event was added, this should never be the case");
            #end
        };
        if(wrap_arbiters==null){
            wrap_arbiters=ZPP_ArbiterList.get(set.arbiters,true);
        }
        else{
            wrap_arbiters.zpp_inner.inner=set.arbiters;
        }
        wrap_arbiters.zpp_inner.zip_length=true;
        wrap_arbiters.zpp_inner.at_ite=null;
    }
    public var body:ZPP_Body=null;
    public var constraint:ZPP_Constraint=null;
    public function new(){
        length=0;
    }
}
