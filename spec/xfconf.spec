Name:           xfconf
Version:        4.20.0
Release:        1%{?dist}
Summary:        Hierarchical configuration system for Xfce

License:        GPLv2+
URL:            https://www.xfce.org/
Source0:        https://archive.xfce.org/src/xfce/xfconf/4.20/xfconf-%{version}.tar.bz2

BuildRequires:  gcc
BuildRequires:  make
BuildRequires:  glib2-devel
BuildRequires:  libxfce4util-devel >= 4.20.0
BuildRequires:  dbus-devel
BuildRequires:  dbus-glib-devel
BuildRequires:  xfce4-dev-tools
BuildRequires:  gettext
BuildRequires:  intltool

%description
Xfconf is a hierarchical (tree-like) configuration system where the
backend is a (possibly shared) D-Bus daemon that manages a set of
configuration channels.

%package        devel
Summary:        Development files for %{name}
Requires:       %{name}%{?_isa} = %{version}-%{release}

%description    devel
Development files for %{name}.

%prep
%autosetup

%build
%configure --disable-static
%make_build

%install
%make_install
find %{buildroot} -name '*.la' -delete

%find_lang xfconf

%files -f xfconf.lang
%license COPYING
%doc AUTHORS ChangeLog NEWS
%{_bindir}/xfconf-query
%{_libdir}/libxfconf-0.so.*
%{_libdir}/gio/modules/libxfsettings-gio.so
%{_datadir}/dbus-1/services/org.xfce.Xfconf.service
%{_libdir}/xfce4/xfconf/xfconfd

%files devel
%{_includedir}/xfce4/xfconf-0/
%{_libdir}/libxfconf-0.so
%{_libdir}/pkgconfig/libxfconf-0.pc

%changelog
* Tue Feb 17 2026 Anders <anders@example.com> - 4.20.0-1
- Initial release for Xfce 4.20
